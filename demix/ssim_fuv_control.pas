unit ssim_fuv_control;

{^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}
{ Part of MICRODEM GIS Program      }
{ PETMAR Trilobite Breeding Ranch   }
{ Released under the MIT Licences   }
{ Copyright (c) 2024 Peter L. Guth  }
{___________________________________}

{$I nevadia_defines.inc}


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  Tfuv_ssim_control = class(TForm)
    GroupBox9: TGroupBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    Hillshade: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    HAND: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox22: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn38: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn38Click(Sender: TObject);
  private
    { Private declarations }
    procedure CheckParameters;

  public
    { Public declarations }
  end;


procedure FUV_SSIM_work;

implementation

{$R *.dfm}

uses
  Petmar_types,DEMDefs,demdef_routines,demix_definitions,Demix_control,DEMstat;


procedure FUV_SSIM_work;
var
  fuv_ssim_control : Tfuv_ssim_control;
begin
   fuv_ssim_control := Tfuv_ssim_control.Create(Application);
   fuv_ssim_control.Show;
   //fuv_ssim_control.Destroy;
end;

procedure Tfuv_ssim_control.FormCreate(Sender: TObject);
begin
   CheckBox12.Checked := MDDef.SSIM_elev;
   CheckBox13.Checked := MDDef.SSIM_slope;
   CheckBox14.Checked := MDDef.SSIM_ruff;
   CheckBox15.Checked := MDDef.SSIM_rri;
   Hillshade.Checked := MDDef.SSIM_hill;
   HAND.Checked := MDDef.SSIM_HAND;
   CheckBox17.Checked := MDDef.SSIM_tpi;
   CheckBox19.Checked := MDDef.SSIM_flow;
   CheckBox20.Checked := MDDef.SSIM_wet;
   CheckBox21.Checked := MDdef.SSIM_ls;
   CheckBox22.Checked := MDDef.DoSSIM;
   CheckBox24.Checked := MDDef.DoFUV;
   CheckBox26.Checked := MDdef.SSIM_ProfC;
   CheckBox27.Checked := MDdef.SSIM_PlanC;
   CheckBox28.Checked := MDDef.SSIM_TangC;
   CheckBox5.Checked := MDDef.DEMIX_overwrite_enabled;
   CheckBox25.Checked := MDDef.OpenMapsFUVSSIM;
   CheckBox6.Checked := MDDef.DEMIX_all_areas;
end;


procedure Tfuv_ssim_control.BitBtn1Click(Sender: TObject);
var
   Areas : tStringList;
begin
   CheckParameters;
   PickWineContestLocation;
   DEMIX_initialized := true;
   Areas := DEMIX_AreasWanted(not MDDef.DEMIX_all_areas);
   ShowSatProgress := false;
   if CheckBox1.Checked then begin
      MDDef.DEMIX_mode := dmClassic;
      AreaSSIMandFUVComputations(MDDef.DEMIX_overwrite_enabled,Areas);
   end;
   if CheckBox2.Checked then begin
      MDDef.DEMIX_mode := dmAddCoastal;
      AreaSSIMandFUVComputations(MDDef.DEMIX_overwrite_enabled,Areas);
   end;
   if CheckBox3.Checked then begin
      MDDef.DEMIX_mode := dmAddDiluvium;
      AreaSSIMandFUVComputations(MDDef.DEMIX_overwrite_enabled,Areas);
   end;
   if CheckBox4.Checked then begin
      MDDef.DEMIX_mode := dmAddDelta;
      AreaSSIMandFUVComputations(MDDef.DEMIX_overwrite_enabled,Areas);
   end;
   ShowSatProgress := true;
end;


procedure Tfuv_ssim_control.BitBtn38Click(Sender: TObject);
begin
    SaveMDdefaults;
end;

procedure Tfuv_ssim_control.CheckParameters;
begin
   MDDef.OpenMapsFUVSSIM := CheckBox25.Checked;
   MDDef.SSIM_elev := CheckBox12.Checked;
   MDDef.SSIM_slope := CheckBox13.Checked;
   MDDef.SSIM_ruff := CheckBox14.Checked;
   MDDef.SSIM_rri := CheckBox15.Checked;
   MDDef.SSIM_tpi := CheckBox17.Checked;
   MDDef.DEMIX_overwrite_enabled := CheckBox5.Checked;
   MDDef.SSIM_flow := CheckBox19.Checked;
   MDDef.SSIM_wet := CheckBox20.Checked;
   MDdef.SSIM_ls := CheckBox21.Checked;
   MDDef.DoSSIM := CheckBox22.Checked;
   MDDef.DoFUV := CheckBox24.Checked;
   MDDef.OpenMapsFUVSSIM := CheckBox25.Checked;
   MDDef.SSIM_ProfC := CheckBox26.Checked;
   MDDef.SSIM_PlanC := CheckBox27.Checked;
   MDDef.SSIM_TangC := CheckBox28.Checked;
   MDDef.DEMIX_all_areas := CheckBox6.Checked;
end;


end.
