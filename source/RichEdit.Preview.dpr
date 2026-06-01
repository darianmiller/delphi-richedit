program RichEdit.Preview;

uses
  Vcl.Forms,
  RichEdit.Preview.MainForm in 'RichEdit.Preview.MainForm.pas' {MainForm},
  RichEdit.SampleSource in 'RichEdit.SampleSource.pas',
  RichEdit.SyntaxHighlighter in 'RichEdit.SyntaxHighlighter.pas',
  Delphi.Lexer in '..\submodules\delphi-lexer\source\Delphi.Lexer.pas',
  Delphi.Token in '..\submodules\delphi-lexer\source\Delphi.Token.pas',
  Delphi.Token.Kind in '..\submodules\delphi-lexer\source\Delphi.Token.Kind.pas',
  Delphi.Token.List in '..\submodules\delphi-lexer\source\Delphi.Token.List.pas',
  Delphi.Token.TriviaSpan in '..\submodules\delphi-lexer\source\Delphi.Token.TriviaSpan.pas',
  Delphi.Keywords in '..\submodules\delphi-lexer\source\Delphi.Keywords.pas',
  Delphi.Lexer.Scanner in '..\submodules\delphi-lexer\source\Delphi.Lexer.Scanner.pas',
  Delphi.Tokenizer in '..\submodules\delphi-lexer\source\Delphi.Tokenizer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi RichEdit Preview';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
