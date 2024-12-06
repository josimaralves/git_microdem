{based on:       }
{https://www.delphitools.info/2024/10/29/supporting-gpu-buffers-for-fmx/}
{https://www.delphitools.info/2024/09/05/faster-3d-point-cloud-with-fmx/}
{https://www.delphitools.info/2024/09/01/exploring-3d-point-clouds-for-fmx/}
{https://github.com/EricGrange}

{$Define Record fmxu_pointcloud}

unit FPointCloud;

interface

{$i fmxu.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.UIConsts, System.Math, System.Diagnostics, System.Math.Vectors,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Viewport3D,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Controls3D,
  FMX.Objects3D, FMX.MaterialSources, FMX.Types3D, System.RTLConsts,
  FMX.Edit, FMX.EditBox, FMX.ComboTrackBar, FMX.ListBox,
  FMXU.D3DShaderCompiler, FMXU.PointCloud, FMXU.Buffers, FMXU.Material.PointColor,
  FMXU.Viewport3D, FMXU.Scene,FMXU.Context.DX11;

type
  TPointCloudForm = class(TForm)
    Viewport3D1: TViewport3D;
    Camera: TCamera;
    DummyTarget: TDummy;
    Panel1: TPanel;
    CBShape: TComboBox;
    CTBPointSize: TComboTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    TimerFPS: TTimer;
    OpenDialog: TOpenDialog;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure CBShapeChange(Sender: TObject);
    procedure CTBPointSizeChangeTracking(Sender: TObject);
    procedure TimerFPSTimer(Sender: TObject);
    procedure Viewport3D1Painting(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
  private
    { Private declarations }
    FMouseDownPos : TPoint3D;
    FPointCloud,
    FPointCloud2,
    FPointCloud3 : TPointCloud3D;
    FRenderCount : Integer;
    FRenderTicks : TStopwatch;
    FRunningFPS : Double;

    procedure OnApplicationIdle(Sender: TObject; var Done: Boolean);
    procedure AutoCenterAndScale(Cloud : TPointCloud3D);
  public
    { Public declarations }
  end;


procedure Startfmxu_point_cloud_viewer;

implementation

{$R *.fmx}

uses
   Petmar,Petmar_types;



procedure Startfmxu_point_cloud_viewer;
var
   PointCloudForm : TPointCloudForm;
begin
   {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('Startfmxu_point_cloud_viewer in'); {$EndIf}
   RegisterDX11ContextU;  //has to be done before the form creation
   {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('DLL registered'); {$EndIf}
   PointCloudForm := TPointCloudForm.Create(Application);
   PointCloudForm.Show;
   {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('Startfmxu_point_cloud_viewer out'); {$EndIf}
end;


procedure TPointCloudForm.AutoCenterAndScale(Cloud : TPointCloud3D);
begin
   var bary := BufferBarycenter(Cloud.Points);
   var factor := 20 / BufferAverageDistance(Cloud.Points, bary);
   BufferOffsetAndScale(Cloud.Points, -bary, factor);
   Cloud.UpdatePoints;
end;


procedure TPointCloudForm.FormCreate(Sender: TObject);

      procedure LoadFromMICRODEMxyzi(fName : String; var cloud : TPointCloud3D);
      const
         MaxPts = 48000000;
      type
         tPointXYZI = record
             x,y,z : double;
             int,int2,int3 : byte;
         end;
         tPointXYZIArray = array[0..MaxPts] of tPointXYZI;
      var
         Points : ^tPointXYZIArray;
         tfile : File;
         Pts : integer;
      begin
           {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('LoadFromMICRODEMxyzi in ' + fName); {$EndIf}
           if FileExists(fName) then begin
              Cloud := TPointCloud3D.Create(Self);
              Cloud.Parent := Viewport3D1;
              Cloud.PointShape := TPointColorShape(1);
              {$IfDef Record3d} WriteLineToDebugFile('LoadMapWithColorByCodes in ' + PointsFile); {$EndIf}
              assignFile(tfile,fName);
              reset(tFile,sizeOf(tPointXYZI));
              new(Points);
              BlockRead(tfile,Points^,MaxPts,Pts);
              CloseFile(tFile);
              {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('Read, pts=' + IntToStr(Pts)); {$EndIf}

               cloud.Points.Length := Pts;
               for var i := 0 to pred(Pts) do begin
                  cloud.Points.Vertices[i] := Point3D(Points^[i].y,Points^[i].x,-Points^[i].z);
                  var c : TAlphaColorRec;
                  c.R := Points^[i].int;
                  c.G := Points^[i].int2;
                  c.B := Points^[i].int3;
                  c.A := 1;
                  cloud.Points.Color0[i] := c.Color;
               end;
              Dispose(Points);
           end;
           {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('LoadFromMICRODEMxyzi out'); {$EndIf}
      end;


begin
   {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('TPointCloudForm.FormCreate in'); {$EndIf}
   Application.OnIdle := OnApplicationIdle;
   FRenderTicks.Start;

   //LoadFromMICRODEMxyzi('C:\Users\pguth\Documents\las_2020_anne_arundel_1.xyzib',FPointCloud);
   LoadFromMICRODEMxyzi('C:\Users\pguth\Documents\Elevation_1.xyzib',FPointCloud);
   LoadFromMICRODEMxyzi('C:\Users\pguth\Documents\Lidar_intensity_1.xyzib',FPointCloud2);
   LoadFromMICRODEMxyzi('C:\Users\pguth\Documents\Lidar_classification_1.xyzib',FPointCloud3);

   AutoCenterAndScale(FPointCloud);
   CBShape.ItemIndex := Ord(pcsPoint);
   CTBPointSizeChangeTracking(Sender);
   CBShapeChange(Sender);
   {$IfDef Record fmxu_pointcloud} WriteLineToDebugFile('TPointCloudForm.FormCreate out'); {$EndIf}
end;

procedure TPointCloudForm.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
   MouseCapture;
   if Button = TMouseButton.mbLeft then begin
      FMouseDownPos.X := X;
      FMouseDownPos.Y := Y;
   end;
end;

procedure TPointCloudForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Single);
begin
   if Shift = [ssLeft ] then begin
      MoveControl3DAroundTarget(Camera, DummyTarget, (Y - FMouseDownPos.Y) * 0.2, (X - FMouseDownPos.X) * 0.2);
      FMouseDownPos.X := X;
      FMouseDownPos.Y := Y;
   end;
end;

procedure TPointCloudForm.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
   ReleaseCapture;
end;

procedure TPointCloudForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
   Camera.AngleOfView := Camera.AngleOfView * Power(1.15, WheelDelta / 120);
end;

procedure TPointCloudForm.CBShapeChange(Sender: TObject);
begin
   FPointCloud.PointShape := TPointColorShape(CBShape.ItemIndex);
end;

procedure TPointCloudForm.CheckBox1Change(Sender: TObject);
begin
   FPointCloud.Visible := CheckBox1.IsChecked;
end;

procedure TPointCloudForm.CheckBox2Change(Sender: TObject);
begin
   FPointCloud2.Visible := CheckBox2.IsChecked;
   AutoCenterAndScale(FPointCloud2);
end;

procedure TPointCloudForm.CheckBox3Change(Sender: TObject);
begin
   FPointCloud3.Visible := CheckBox3.IsChecked;
   AutoCenterAndScale(FPointCloud3);
end;

procedure TPointCloudForm.CTBPointSizeChangeTracking(Sender: TObject);
begin
   FPointCloud.PointSize := CTBPointSize.Value / 100;
end;

procedure TPointCloudForm.OnApplicationIdle(Sender: TObject; var Done: Boolean);
begin
   Viewport3D1.Repaint;
   Done := False;
end;

procedure TPointCloudForm.TimerFPSTimer(Sender: TObject);
begin
   var count := FRenderCount;
   var elapsed := FRenderTicks.ElapsedMilliseconds;

   var fps : Double := 0;
   if count > 0 then
      fps := count / elapsed * 1000;

   FRenderTicks.Reset;
   FRenderTicks.Start;
   FRenderCount := 0;

   var paintFPS := 0.0;
   if Viewport3D1.LastPaintSeconds > 0 then
      paintFPS := 1 / Viewport3D1.LastPaintSeconds;
   FRunningFPS := FRunningFPS * 0.5  + fps * 0.5;

   Caption := Format(
      '%.1f ms paint (%.1f FPS) / %.1f actual FPS / %d points',
      [ Viewport3D1.LastPaintSeconds*1000, paintFPS, FRunningFPS, FPointCloud.Points.Length ]
   );
end;

procedure TPointCloudForm.Viewport3D1Painting(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
   Inc(FRenderCount);
end;


end.
