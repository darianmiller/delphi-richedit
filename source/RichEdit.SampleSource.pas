unit RichEdit.SampleSource;

interface

function GetSampleDelphiSource: string;

implementation

function GetSampleDelphiSource: string;
begin
  Result :=
    'unit Sample.Calculator;' + sLineBreak +
    '' + sLineBreak +
    'interface' + sLineBreak +
    '' + sLineBreak +
    'uses' + sLineBreak +
    '  System.SysUtils,' + sLineBreak +
    '  System.Classes,' + sLineBreak +
    '  System.Generics.Collections;' + sLineBreak +
    '' + sLineBreak +
    'type' + sLineBreak +
    '  /// <summary>Simple RPN calculator with operator precedence</summary>' + sLineBreak +
    '  TCalculator = class' + sLineBreak +
    '  strict private' + sLineBreak +
    '    FStack: TStack<Double>;' + sLineBreak +
    '    FHistory: TStringList;' + sLineBreak +
    '    FPrecision: Integer;' + sLineBreak +
    '  private' + sLineBreak +
    '    procedure Push(const AValue: Double);' + sLineBreak +
    '    function Pop: Double;' + sLineBreak +
    '  public' + sLineBreak +
    '    constructor Create(const APrecision: Integer = 6);' + sLineBreak +
    '    destructor Destroy; override;' + sLineBreak +
    '    function Evaluate(const AExpression: string): Double;' + sLineBreak +
    '    property Precision: Integer read FPrecision write FPrecision;' + sLineBreak +
    '    property History: TStringList read FHistory;' + sLineBreak +
    '  end;' + sLineBreak +
    '' + sLineBreak +
    '  ECalculatorError = class(Exception);' + sLineBreak +
    '' + sLineBreak +
    'implementation' + sLineBreak +
    '' + sLineBreak +
    'const' + sLineBreak +
    '  MAX_STACK_DEPTH = 256;' + sLineBreak +
    '  HEX_PREFIX = $FF;' + sLineBreak +
    '  BIN_PREFIX = %10101010;' + sLineBreak +
    '' + sLineBreak +
    '{ TCalculator }' + sLineBreak +
    '' + sLineBreak +
    'constructor TCalculator.Create(const APrecision: Integer = 6);' + sLineBreak +
    'begin' + sLineBreak +
    '  inherited Create;' + sLineBreak +
    '  FStack := TStack<Double>.Create;' + sLineBreak +
    '  FHistory := TStringList.Create;' + sLineBreak +
    '  FPrecision := APrecision;' + sLineBreak +
    'end;' + sLineBreak +
    '' + sLineBreak +
    'destructor TCalculator.Destroy;' + sLineBreak +
    'begin' + sLineBreak +
    '  FHistory.Free;' + sLineBreak +
    '  FStack.Free;' + sLineBreak +
    '  inherited;' + sLineBreak +
    'end;' + sLineBreak +
    '' + sLineBreak +
    'procedure TCalculator.Push(const AValue: Double);' + sLineBreak +
    'begin' + sLineBreak +
    '  if FStack.Count >= MAX_STACK_DEPTH then' + sLineBreak +
    '    raise ECalculatorError.Create(''Stack overflow'');' + sLineBreak +
    '  FStack.Push(AValue);' + sLineBreak +
    'end;' + sLineBreak +
    '' + sLineBreak +
    'function TCalculator.Pop: Double;' + sLineBreak +
    'begin' + sLineBreak +
    '  if FStack.Count = 0 then' + sLineBreak +
    '    raise ECalculatorError.Create(''Stack underflow'');' + sLineBreak +
    '  Result := FStack.Pop;' + sLineBreak +
    'end;' + sLineBreak +
    '' + sLineBreak +
    'function TCalculator.Evaluate(const AExpression: string): Double;' + sLineBreak +
    'var' + sLineBreak +
    '  Tokens: TArray<string>;' + sLineBreak +
    '  Token: string;' + sLineBreak +
    '  Value: Double;' + sLineBreak +
    '  A, B: Double;' + sLineBreak +
    'begin' + sLineBreak +
    '  {$REGION ''Tokenize input''}' + sLineBreak +
    '  Tokens := AExpression.Split(['' ''], TStringSplitOptions.ExcludeEmpty);' + sLineBreak +
    '  {$ENDREGION}' + sLineBreak +
    '' + sLineBreak +
    '  for Token in Tokens do' + sLineBreak +
    '  begin' + sLineBreak +
    '    // Try to parse as a number first' + sLineBreak +
    '    if TryStrToFloat(Token, Value) then' + sLineBreak +
    '      Push(Value)' + sLineBreak +
    '    else if Token = ''+'' then' + sLineBreak +
    '    begin' + sLineBreak +
    '      B := Pop;' + sLineBreak +
    '      A := Pop;' + sLineBreak +
    '      Push(A + B);' + sLineBreak +
    '    end' + sLineBreak +
    '    else if Token = ''-'' then' + sLineBreak +
    '    begin' + sLineBreak +
    '      B := Pop;' + sLineBreak +
    '      A := Pop;' + sLineBreak +
    '      Push(A - B);' + sLineBreak +
    '    end' + sLineBreak +
    '    else if Token = ''*'' then' + sLineBreak +
    '    begin' + sLineBreak +
    '      B := Pop;' + sLineBreak +
    '      A := Pop;' + sLineBreak +
    '      Push(A * B);' + sLineBreak +
    '    end' + sLineBreak +
    '    else if Token = ''/'' then' + sLineBreak +
    '    begin' + sLineBreak +
    '      B := Pop;' + sLineBreak +
    '      A := Pop;' + sLineBreak +
    '      if B = 0.0 then' + sLineBreak +
    '        raise ECalculatorError.Create(''Division by zero'');' + sLineBreak +
    '      Push(A / B);' + sLineBreak +
    '    end' + sLineBreak +
    '    else' + sLineBreak +
    '      raise ECalculatorError.CreateFmt(''Unknown token: %s'', [Token]);' + sLineBreak +
    '  end;' + sLineBreak +
    '' + sLineBreak +
    '  (* Validate final stack state *)' + sLineBreak +
    '  if FStack.Count <> 1 then' + sLineBreak +
    '    raise ECalculatorError.CreateFmt(' + sLineBreak +
    '      ''Invalid expression: %d values remain on stack'', [FStack.Count]);' + sLineBreak +
    '' + sLineBreak +
    '  Result := Pop;' + sLineBreak +
    '  FHistory.Add(Format(''%s = %.*f'', [AExpression, FPrecision, Result]));' + sLineBreak +
    'end;' + sLineBreak +
    '' + sLineBreak +
    'end.';
end;

end.
