unit RichEdit.Preview.MainForm;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    panLeft: TPanel;
    Splitter1: TSplitter;
    panClient: TPanel;
    panBottom: TPanel;
    panTop: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    FRichEdit: TRichEdit;
    FHighlightTimer: TTimer;
    procedure ConfigureRichEdit;
    procedure LoadSampleSource;
    procedure RichEditChange(Sender: TObject);
    procedure HighlightTimerFire(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  RichEdit.SampleSource,
  RichEdit.SyntaxHighlighter;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ConfigureRichEdit;
  LoadSampleSource;
end;

procedure TMainForm.ConfigureRichEdit;
begin
  FRichEdit := TRichEdit.Create(Self);
  FRichEdit.Parent := panClient;
  FRichEdit.Align := alClient;
  FRichEdit.ScrollBars := ssBoth;
  FRichEdit.WordWrap := False;
  FRichEdit.WantTabs := True;
  FRichEdit.Font.Name := 'Consolas';
  FRichEdit.Font.Size := 11;
  FRichEdit.Font.Color := clWindowText;
  FRichEdit.Color := clWindow;

  // Increase the default text limit from 64KB
  FRichEdit.MaxLength := MaxInt;

  FRichEdit.OnChange := RichEditChange;

  FHighlightTimer := TTimer.Create(Self);
  FHighlightTimer.Interval := 250;
  FHighlightTimer.Enabled := False;
  FHighlightTimer.OnTimer := HighlightTimerFire;
end;

procedure TMainForm.LoadSampleSource;
begin
  FRichEdit.OnChange := nil;
  try
    FRichEdit.Lines.Text := GetSampleDelphiSource;
    HighlightRichEdit(FRichEdit);
    FRichEdit.SelStart := 0;
    FRichEdit.SelLength := 0;
  finally
    FRichEdit.OnChange := RichEditChange;
  end;
end;

procedure TMainForm.RichEditChange(Sender: TObject);
begin
  FHighlightTimer.Enabled := False;
  FHighlightTimer.Enabled := True;
end;

procedure TMainForm.HighlightTimerFire(Sender: TObject);
begin
  FHighlightTimer.Enabled := False;
  FRichEdit.OnChange := nil;
  try
    HighlightRichEdit(FRichEdit);
  finally
    FRichEdit.OnChange := RichEditChange;
  end;
end;

end.
