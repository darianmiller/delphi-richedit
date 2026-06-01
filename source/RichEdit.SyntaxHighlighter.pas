unit RichEdit.SyntaxHighlighter;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.RichEdit,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.ComCtrls,
  Delphi.Lexer,
  Delphi.Token,
  Delphi.Token.Kind,
  Delphi.Token.List;

procedure HighlightRichEdit(const ARichEdit: TRichEdit);

implementation

const
  // Token kinds that use default formatting (clWindowText, no bold/italic).
  // These are skipped in the per-token loop after applying the default via SCF_ALL.
  DEFAULT_STYLE_TOKENS = [tkIdentifier, tkSymbol, tkWhitespace, tkEOL, tkBOM, tkEOF, tkInvalid, tkInactiveCode];

var
  TokenFormats: array[TTokenKind] of TCharFormat2;
  DefaultFormat: TCharFormat2;

procedure InitTokenFormat(AKind: TTokenKind; AColor: TColor; AStyle: TFontStyles);
begin
  FillChar(TokenFormats[AKind], SizeOf(TCharFormat2), 0);
  TokenFormats[AKind].cbSize := SizeOf(TCharFormat2);
  TokenFormats[AKind].dwMask := CFM_COLOR or CFM_BOLD or CFM_ITALIC;
  TokenFormats[AKind].crTextColor := ColorToRGB(AColor);
  TokenFormats[AKind].dwEffects := 0;
  if fsBold in AStyle then
    TokenFormats[AKind].dwEffects := TokenFormats[AKind].dwEffects or CFE_BOLD;
  if fsItalic in AStyle then
    TokenFormats[AKind].dwEffects := TokenFormats[AKind].dwEffects or CFE_ITALIC;
end;

procedure InitFormats;
begin
  FillChar(DefaultFormat, SizeOf(TCharFormat2), 0);
  DefaultFormat.cbSize := SizeOf(TCharFormat2);
  DefaultFormat.dwMask := CFM_COLOR or CFM_BOLD or CFM_ITALIC;
  DefaultFormat.crTextColor := ColorToRGB(clWindowText);
  DefaultFormat.dwEffects := 0;

  InitTokenFormat(tkStrictKeyword,  clNavy,   [fsBold]);
  InitTokenFormat(tkContextKeyword, clNavy,   [fsBold]);
  InitTokenFormat(tkNumber,         clBlue,   []);
  InitTokenFormat(tkString,         clPurple, []);
  InitTokenFormat(tkCharLiteral,    clPurple, []);
  InitTokenFormat(tkComment,        clGreen,  [fsItalic]);
  InitTokenFormat(tkDirective,      clTeal,   []);
  InitTokenFormat(tkAsmBody,        clGray,   []);
end;

function GetRichEditText(const ARichEdit: TRichEdit): string;
var
  LenEx: TGetTextLengthEx;
  GetEx: TGetTextEx;
  Len: Integer;
begin
  LenEx.flags := GTL_DEFAULT or GTL_PRECISE;
  LenEx.codepage := 1200; // Unicode UTF-16le
  Len := SendMessage(ARichEdit.Handle, EM_GETTEXTLENGTHEX, WPARAM(@LenEx), 0);
  if Len <= 0 then
    Exit('');

  SetLength(Result, Len);

  FillChar(GetEx, SizeOf(GetEx), 0);
  GetEx.cb := (Len + 1) * SizeOf(Char);
  GetEx.flags := GT_DEFAULT;
  GetEx.codepage := 1200;
  SendMessage(ARichEdit.Handle, EM_GETTEXTEX, WPARAM(@GetEx), LPARAM(PChar(Result)));
end;

function SameFormat(const A, B: TCharFormat2): Boolean; inline;
begin
  Result := (A.crTextColor = B.crTextColor) and (A.dwEffects = B.dwEffects);
end;

procedure HighlightRichEdit(const ARichEdit: TRichEdit);
var
  Lexer: TDelphiLexer;
  Tokens: TTokenList;
  Items: TArray<TToken>;
  Count, I: Integer;
  Source: string;
  Wnd: HWND;
  SaveSel: TCharRange;
  SaveScroll: TPoint;
  SaveMask: LPARAM;
  RunStart, RunEnd: Integer;
  RunFmt: ^TCharFormat2;
begin
  Wnd := ARichEdit.Handle;

  // Save state: selection, scroll position, event mask
  SendMessage(Wnd, EM_EXGETSEL, 0, LPARAM(@SaveSel));
  SendMessage(Wnd, EM_GETSCROLLPOS, 0, LPARAM(@SaveScroll));
  SaveMask := SendMessage(Wnd, EM_SETEVENTMASK, 0, 0);

  SendMessage(Wnd, WM_SETREDRAW, WPARAM(False), 0);
  try
    Source := GetRichEditText(ARichEdit);

    // Reset entire document to default formatting in one call
    SendMessage(Wnd, EM_SETSEL, 0, -1);
    SendMessage(Wnd, EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(@DefaultFormat));

    Lexer := TDelphiLexer.Create;
    try
      Tokens := Lexer.Tokenize(Source);
      try
        Items := Tokens.List;
        Count := Tokens.Count;
        I := 0;
        while I < Count do
        begin
          // Skip default-styled tokens
          if Items[I].Kind in DEFAULT_STYLE_TOKENS then
          begin
            Inc(I);
            Continue;
          end;

          // Start a new formatting run
          RunFmt := @TokenFormats[Items[I].Kind];
          RunStart := Items[I].StartOffset;
          RunEnd := Items[I].StartOffset + Items[I].Length;

          // Coalesce directly adjacent same-format tokens (no gap between them).
          // We cannot skip across default-styled tokens because the EM_SETCHARFORMAT
          // on the merged range would override their default formatting.
          while (I + 1 < Count)
            and not (Items[I + 1].Kind in DEFAULT_STYLE_TOKENS)
            and (Items[I + 1].StartOffset = RunEnd)
            and SameFormat(RunFmt^, TokenFormats[Items[I + 1].Kind]) do
          begin
            Inc(I);
            RunEnd := Items[I].StartOffset + Items[I].Length;
          end;

          SendMessage(Wnd, EM_SETSEL, WPARAM(RunStart), LPARAM(RunEnd));
          SendMessage(Wnd, EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(RunFmt));

          Inc(I);
        end;
      finally
        Tokens.Free;
      end;
    finally
      Lexer.Free;
    end;

    // Restore selection and scroll position
    SendMessage(Wnd, EM_EXSETSEL, 0, LPARAM(@SaveSel));
    SendMessage(Wnd, EM_SETSCROLLPOS, 0, LPARAM(@SaveScroll));
  finally
    SendMessage(Wnd, WM_SETREDRAW, WPARAM(True), 0);
    SendMessage(Wnd, EM_SETEVENTMASK, 0, SaveMask);
    RedrawWindow(Wnd, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
  end;
end;

initialization
  InitFormats;

end.
