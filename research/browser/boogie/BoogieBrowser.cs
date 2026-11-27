using System.Globalization;
using System.Runtime.InteropServices.JavaScript;
using System.Runtime.Versioning;
using Microsoft.Boogie;

[SupportedOSPlatform("browser")]
public static partial class BoogieBrowser
{
    public static void Main() { }

    [JSExport]
    public static string[] Verify(string program, string input, int timeoutSeconds, int seed)
    {
        const string model = "proof.model";
        var previousOut = Console.Out;
        var previousError = Console.Error;
        using var output = new StringWriter(CultureInfo.InvariantCulture);
        using var error = new StringWriter(CultureInfo.InvariantCulture);
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(Path.GetFullPath(input))!);
            File.WriteAllText(input, program);
            File.Delete(model);
            Console.SetOut(output);
            Console.SetError(error);
            var args = new List<string> {"/vcsCores:1", "/trace", "/errorLimit:0", "/mv:" + model};
            if (timeoutSeconds > 0)
                args.Add("/timeLimit:" + timeoutSeconds.ToString(CultureInfo.InvariantCulture));
            if (seed >= 0)
                args.Add("/proverOpt:O:smt.random_seed=" + seed.ToString(CultureInfo.InvariantCulture));
            args.Add(input);
            var code = OnlyBoogie.Main(args.ToArray());
            return new[] {
                code.ToString(CultureInfo.InvariantCulture), output.ToString(), error.ToString(),
                File.Exists(model) ? File.ReadAllText(model) : "",
            };
        }
        catch (Exception failure)
        {
            return new[] { "1", output.ToString(), failure.ToString(), "" };
        }
        finally
        {
            Console.SetOut(previousOut);
            Console.SetError(previousError);
            File.Delete(input);
            File.Delete(model);
        }
    }
}
