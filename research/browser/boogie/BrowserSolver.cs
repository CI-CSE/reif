using System;
using System.Runtime.InteropServices.JavaScript;
using System.Runtime.Versioning;

namespace Microsoft.Boogie.SMTLib;

[SupportedOSPlatform("browser")]
internal sealed partial class BrowserSolver : IDisposable
{
  private readonly int context = Open();
  private bool closed;

  public string Evaluate(string commands) => Evaluate(context, commands);

  public void Dispose()
  {
    if (!closed)
    {
      Close(context);
      closed = true;
    }
  }

  [JSImport("open", "reif-z3")]
  internal static partial int Open();

  [JSImport("evaluate", "reif-z3")]
  internal static partial string Evaluate(int context, string commands);

  [JSImport("close", "reif-z3")]
  internal static partial void Close(int context);
}
