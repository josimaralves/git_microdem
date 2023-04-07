unit tissot;

{^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}
{ Part of MICRODEM GIS Program      }
{ PETMAR Trilobite Breeding Ranch   }
{ Released under the MIT Licences   }
{ Copyright (c) 2023 Peter L. Guth  }
{___________________________________}


{$I nevadia_defines.inc}

{$IfDef RecordProblems}   //normally only defined for debugging specific problems
{$Endif}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  DEMMapf;

type
  TTissotOpts = class(TForm)
    HelpBtn: TBitBtn;
    OKBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    Edit4: TEdit;
    RadioGroup1: TRadioGroup;
    CheckBox2: TCheckBox;
    Label5: TLabel;
    Edit5: TEdit;
    SpeedButton1: TSpeedButton;
    CheckBox1: TCheckBox;
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MapOwner : tMapform;
  end;


procedure GetTissotOptions(inMapOwner : tMapForm;GridEnabled : boolean = true);

implementation

{$R *.dfm}

uses
   DEMDefs,Petmar,Petmar_types;


procedure GetTissotOptions;
var
  TissotOpts: TTissotOpts;
begin
  TissotOpts := TTissotOpts.Create(Application);
  with TissotOpts do begin
     MapOwner := InMapOwner;
     SpeedButton1.Enabled := MapOwner <> Nil;
     Edit1.Text := RealToString(MDDef.TissotLatGridInc,-8,-2);
     Edit2.Text := RealToString(MDDef.TissotLongGridInc,-8,-2);
     Edit3.Text := IntToStr(MDDef.TissotRadius);
     Edit4.Text := IntToStr(MDDef.TissotPixelSpacing);
     Petmar.ColorLineWidthBitBtn(BitBtn1,MDDef.TissotColor,MDDef.TissotLineWidth);
     CheckBox1.Checked := MDDef.SimpleTissotCylindrical;
     CheckBox2.Checked := MDDef.ShowTissotHK;
     Edit5.Text := IntToStr(MDDef.TissotHKdecimals);

     RadioGroup1.Enabled := GridEnabled;
     if MDDef.TissotSpaceByPixels then RadioGroup1.ItemIndex := 1 else RadioGroup1.ItemIndex := 0;
     ShowModal;
     SpeedButton1Click(nil);
  end;
end;


procedure TTissotOpts.BitBtn1Click(Sender: TObject);
begin
   PickLineSizeAndColor('Tissot indicatrix',BitBtn1,MDDef.TissotColor,MDDef.TissotLineWidth);
end;

procedure TTissotOpts.Edit1Change(Sender: TObject);
begin
   CheckEditString(Edit1.Text,MDDef.TissotLatGridInc);
end;

procedure TTissotOpts.Edit2Change(Sender: TObject);
begin
   CheckEditString(Edit2.Text,MDDef.TissotLongGridInc);
end;


procedure TTissotOpts.Edit4Change(Sender: TObject);
begin
   CheckEditString(Edit4.Text,MDDef.TissotPixelSpacing);
end;

procedure TTissotOpts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Action := caFree;
end;

procedure TTissotOpts.HelpBtnClick(Sender: TObject);
begin
   DisplayHTMLTopic('html\tissot_opts.htm');
end;

procedure TTissotOpts.OKBtnClick(Sender: TObject);
begin
   SpeedButton1Click(nil);
   Close;
end;

procedure TTissotOpts.RadioGroup1Click(Sender: TObject);
begin
    Edit1.Enabled := RadioGroup1.Enabled and (RadioGroup1.ItemIndex = 0);
    Edit2.Enabled := RadioGroup1.Enabled and (RadioGroup1.ItemIndex = 0);
    Label1.Enabled := RadioGroup1.Enabled and (RadioGroup1.ItemIndex = 0);
    Label2.Enabled := RadioGroup1.Enabled and (RadioGroup1.ItemIndex = 0);
    Edit4.Enabled := RadioGroup1.Enabled and (RadioGroup1.ItemIndex = 1);
    Label4.Enabled := RadioGroup1.Enabled and (RadioGroup1.ItemIndex = 1);
end;


procedure TTissotOpts.SpeedButton1Click(Sender: TObject);
begin
   CheckEditString(Edit3.Text,MDDef.TissotRadius);
   CheckEditString(Edit5.Text,MDDef.TissotHKdecimals);
   MDDef.ShowTissotHK := CheckBox2.Checked;
   MDDef.SimpleTissotCylindrical := CheckBox1.Checked;
   MDDef.TissotSpaceByPixels := RadioGroup1.ItemIndex = 1;

   if (MapOwner <> Nil) then MapOwner.OverlayTissot;
end;



end.
