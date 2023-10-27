note
	description: "Task to translate a chunk of Eiffel to an IV AST."
	date: "$Date: 2014-02-27 22:16:46 +0800 (Thu, 27 Feb 2014) $"
	revision: "$Revision: 94536 $"

class
	E2B_TRANSLATE_OPTIMIZE_TASK

inherit

	ROTA_TASK_I

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_translator_input: E2B_TRANSLATOR_INPUT; a_boogie_universe: IV_UNIVERSE)
			-- Initialize task.
		do
			create translator.make (a_boogie_universe)
			l_boogie_universe := a_boogie_universe
            l_translator_input := a_translator_input
			-- translator.add_input (a_translator_input)
			has_next_step := True
			flag := True
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

    l_translator_input: E2B_TRANSLATOR_INPUT
            -- Translator input

    flag: BOOLEAN
           -- flag to indicate whether it's the first translation

    l_boogie_universe: IV_UNIVERSE

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	started: BOOLEAN

	step
			-- <Precursor>
		local
			l_end_tick: NATURAL
			l_untranslated: INTEGER
			l_total: INTEGER
		do
				-- Translate features for some milliseconds

			if flag then
			 -- translator.translation_pool.reset
			 translator.add_input (l_translator_input)
			 -- l_boogie_universe.declarations.wipe_out
		    end

            flag := False

			from
				l_end_tick := end_tick_for_duration (100)
			until
				clock_ticks > l_end_tick or not translator.has_next_step
			loop
				translator.step
			end
			has_next_step := translator.has_next_step -- and flag
			l_untranslated := translation_pool.untranslated_elements.count
			l_total := l_untranslated + translation_pool.translated_elements.count
			-- set_status (messages.status_translating (l_untranslated, l_total))

		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {E2B_VERIFY_TASK} -- Implementation

	translator: E2B_TRANSLATOR
			-- Translator to generate Boogie code.

	clock_ticks: NATURAL
			-- Elapsed clock ticks since start of program.
		external "C inline use <time.h>"
		alias
			"return clock();"
		end

	end_tick_for_duration (a_milliseconds: REAL): NATURAL
			-- Tick count for `a_milliseconds' in future.
		external "C inline use <time.h>"
		alias
			"return clock() + ($a_milliseconds * (CLOCKS_PER_SEC / 1000));"
		end

note
	license: "GNU General Public License"
	license_name: "GPL"
	EIS: "name=GPL", "src=https://www.gnu.org/licenses/gpl.html", "tag=license"
	copying: "[
		This program is free software; you can redistribute it and/or modify it under the terms of
		the GNU General Public License as published by the Free Software Foundation; either version 1,
		or (at your option) any later version.

		This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
		without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
		See the GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along with this program.
		If not, see <https://www.gnu.org/licenses/>.
	]"
end
