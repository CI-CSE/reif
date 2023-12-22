#!/usr/bin/env python3

import os
import os.path
import platform
import sys
import time
import shutil
import subprocess
import argparse
import difflib

# ----------------------------------------------------------------------------
# paths
# ----------------------------------------------------------------------------

def tests_ecf_path():
	return os.path.join(base_path, 'tests.ecf')

store_output = False

use_finalized_eve_exe = False
override_ec = None
def eve_exe_path():
	if override_ec:
		return override_ec

	mode = 'F_code' if use_finalized_eve_exe else 'W_code'
	exe = 'ec.exe' if platform.system() == 'Windows' else 'ec'
	return os.path.realpath(os.path.join(os.getenv("EIFFEL_SRC"), "Eiffel", "Ace", "EIFGENs", "bench", mode, exe))


# ----------------------------------------------------------------------------
# helper functions: log and printing
# ----------------------------------------------------------------------------

# clear log file
open("log.txt", 'w').close()
# open log file
_log_file = open("log.txt", 'w')

_has_colorama = False
try:
	from colorama import init, Fore, Back, Style
	init()
	_has_colorama = True
except ImportError:
	pass

def _to_logfile(text):
	_log_file.write(time.strftime('%H:%M:%S', time.gmtime(time.perf_counter())))
	_log_file.write("  ---  ")
	_log_file.write(text)
	_log_file.write("\n")
	_log_file.flush()

def _as_info(text, pre=''):
	print(pre + text)
	_to_logfile(pre + text)

def _as_warning(text, pre=''):
	if _has_colorama:
		print(pre + Fore.YELLOW + Style.BRIGHT + text + Style.RESET_ALL)
	else:
		print(pre + text)
	_to_logfile(pre + text)

def _as_error(text, pre=''):
	if _has_colorama:
		print(pre + Fore.RED + Style.BRIGHT + text + Style.RESET_ALL)
	else:
		print(pre + text)
	_to_logfile(pre + text)

def _as_success(text, pre=''):
	if _has_colorama:
		print(pre + Fore.GREEN + Style.BRIGHT + text + Style.RESET_ALL)
	else:
		print(pre + text)
	_to_logfile(pre + text)


# ----------------------------------------------------------------------------
# helper functions: compiling and running
# ----------------------------------------------------------------------------

def delete_path(path):
	result = False
	if os.path.isdir(path):
		shutil.rmtree(path, ignore_errors=False)
	elif os.path.isfile(path):
		os.remove(path)
	if os.path.exists(path):
		_as_error("Unable to delete '" + path + "'")
	else:
		result = True
	return result

def execute(program, output_file = None):
	print("EXECUTE", ' '.join(program))
	if isinstance(output_file, str):
		pipe = open(output_file, 'a')
	else:
		pipe = output_file
	proc = subprocess.Popen(program, stdin=pipe, stdout=pipe, stderr=pipe)
	try:
		proc.communicate(timeout=test_timeout)
	except subprocess.TimeoutExpired:
		proc.kill()
		proc.communicate() # finish communication
		pipe.write('Killed by test timeout\n')

	if isinstance(output_file, str):
		pipe.close()
	return proc.returncode

def compile_tests():
	global _log_file, base_path
	_as_info("Compiling tests")
	if os.path.isfile(tests_ecf_path()):
		delete_path(os.path.join(base_path, "EIFGENs", "tests"))
		olddir = os.getcwd()
		os.chdir(os.path.dirname(base_path))
		code = execute([eve_exe_path(), "-config", tests_ecf_path(), "-target", "tests", "-batch"], _log_file)
		os.chdir(olddir)
		if code == 0:
			_as_success("Compilation of tests successful")
		else:
			_as_error("Compilation of tests failed")
	else:
		_as_error("ECF file '" + tests_ecf_path() + "' does not exist")

def is_test_path(path):
	if not os.path.isdir(path):
		return False
	if not os.path.isfile(os.path.join(path, "output.txt")):
		return False
	return True

def find_test(test, directory=None):
	global base_path
	if directory is None:
		directory = base_path
	for name in os.listdir(directory):
		temp = os.path.join(directory, name)
		if name == test and is_test_path(temp):
			return temp
		elif os.path.isdir(temp):
			temp2 = find_test(test, temp)
			if not temp2 is None:
				return temp2
	return None

def run_tests(directory=None, args_prefix=[]):
	'''Run tests

	Returns dict 'passed', 'failed', 'error', 'timeout' to counts'''
	global base_path

	result = {
		'passed': 0,
		'failed': 0,
		'error': 0,
		'timeout': 0
	}

	if directory is None:
		directory = base_path
	for test_name in os.listdir(directory):
		path = os.path.join(directory, test_name)
		if path.endswith("args.txt"):
			args = open(path).readline().strip().split(' ')
			_as_info("  command line options: " + str(args))
			args_prefix.extend(args)
		elif os.path.isdir(path):
			if is_test_path(path):
				r = run_test(path, test_name, args_prefix)
				result[r] += 1
			elif not path.endswith("EIFGENs"):
				r = run_tests(path, args_prefix)
				for k in r:
					result[k] += r[k]
	return result

def run_test(path, test_name, args_prefix=[]):
	'''Run a single test case,

	return 'passed' if test passed,
	'failed' if test failed,
	'error' if there was error running test
	'timeout' if running the test exceeded the timeout time'''
	global store_output
	if not path is None and os.path.isdir(path):
		_as_info("Running test: " + test_name)
		args = [eve_exe_path(), "-config", tests_ecf_path(), "-target", "tests", "-autoproof", "-noprinttime"] + args_prefix
		classes = []
		for filename in sorted(os.listdir(path)):
			if filename.endswith(".e"):
				class_name = os.path.splitext(os.path.basename(filename))[0]
				classes.append(class_name.upper())
			elif filename.endswith("args.txt"):
				args_txt = open(os.path.join(path, filename)).readline().strip().split(' ')
				_as_info("  command line options: " + str(args_txt))
				args.extend(args_txt)
		args.extend(classes)

		# clear output file
		open("autoproof_output.txt", 'w').close()
		execute(args, "autoproof_output.txt")
		
		output_file = open("autoproof_output.txt", 'r')
		output_content = output_file.read()
		full_output = output_content
		output_content = output_content.partition("System Recompiled.\n")[2].strip()
		output_file.close()
		
		if store_output:
			output_file = open(os.path.join(path, "output.txt"), 'w')
			output_file.write(output_content)
			output_file.close()
			
		expected_file = open(os.path.join(path, "output.txt"), 'r')
		expected_content = expected_file.read().strip()
		expected_file.close()
	
		if output_content == expected_content:
			_as_success(test_name + ": successful")
			return 'passed'
		else:
			if output_content.endswith('Killed by test timeout'):
				_as_error(test_name+ ": timeout")
				return 'timeout'

			_as_error(test_name + ": failed")
			print('Full output:')
			print(full_output)
			print('diff:')
			for line in difflib.unified_diff(output_content.split("\n"), expected_content.split("\n")):
				_as_info(line)
			return 'failed'
	else:
		_as_error("test '" + test_name + "' does not exist")
		return 'error'



# ----------------------------------------------------------------------------
# parse arguments and execute actions
# ----------------------------------------------------------------------------

parser = argparse.ArgumentParser()
parser.add_argument('--clean', '-c', action='store_true')
parser.add_argument('--store', '-s', action='store_true')
parser.add_argument('--finalized', '-f', action='store_true')
parser.add_argument('--dir', '-d', default=None)
parser.add_argument('--ec', help='Path to the \'ec\' executable to use')
parser.add_argument('--test-timeout', default=30, type=int)
parser.add_argument('tests', nargs=argparse.REMAINDER)

arguments = parser.parse_args()
test_timeout = arguments.test_timeout

base_path = arguments.dir or '.'

if arguments.finalized:
	use_finalized_eve_exe = True
if arguments.store:
	store_output = True
if arguments.ec:
	override_ec = arguments.ec

if arguments.clean:
	compile_tests()

if len(arguments.tests) == 0:
	result = run_tests(base_path)
else:
	result  = {
		'passed': 0,
		'failed': 0,
		'error': 0,
		'timeout': 0
	}
	for t in arguments.tests:
		outcome = run_test(find_test(t, base_path), t)
		result[outcome] += 1

print(result)

if result['failed'] or result['error'] or result['timeout']:
	exit(1)
