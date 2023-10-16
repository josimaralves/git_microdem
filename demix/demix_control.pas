unit demix_control;

{^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}
{ Part of MICRODEM GIS Program      }
{ PETMAR Trilobite Breeding Ranch   }
{ Released under the MIT Licences   }
{ Copyright (c) 2023 Peter L. Guth  }
{___________________________________}


//    10/1/2023: DEMIX options under active development.  Some options are hard coded and not error-trapped, and some options may not longer work.  Used with caution

{$I nevadia_defines.inc}

{$IfDef RecordProblems}   //normally only defined for debugging specific problems
   {$Define RecordDEMIX}
   //{$Define RecordDEMIXLoad}
   //{$Define RecordDEMIXStart}
   //{$Define RecordDEMIXsave}
   //{$Define RecordCreateHalfSec}
   //{$Define RecordHalfSec}
   //{$Define RecordTileStats}

   //{$Define RecordTileProcessing}
   //{$Define Record3DEPX}
   //{$Define RecordCriteriaEvaluation}
   //{$Define RecordDEMIXSortGraph}
   //{$Define RecordGridCompare}
   //{$Define RecordDEMIXRefDEMopen}
   //{$Define RecordUseTile}

   //{$Define RecordDEMIXMovies}
   //{$Define RecordDEMIXVDatum}
   //{$Define RecordFullDEMIX}
   //{$Define ShowDEMIXWhatsOpen}
{$EndIf}


interface

uses
//needed for inline of core DB functions
   Petmar_db,
   Data.DB,

   {$IfDef UseFireDacSQLlite}
      FireDAC.Stan.ExprFuncs,
      FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
      FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
      FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
      FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
      FireDAC.Phys.SQLite, FireDAC.Comp.UI,
   {$EndIf}

   {$IfDef UseTDBF}
      dbf,
   {$EndIf}

   {$IfDef UseTCLientDataSet}
      DBClient,
   {$EndIf}
//end core DB functions definitions

    System.SysUtils,System.Classes,System.UITypes,
    StrUtils,dbGrids,
    VCL.ExtCtrls,VCL.Forms, VCL.Graphics, VCL.Controls,
    WinAPI.Windows,
    Petmar,Petmar_types,BaseGraf,
    DEMDefs;

const
   DEMIXSkipFilesAlreadyDone = true;
   FilterOutSeaLevel = false;

const
   DEMisDTM = 2;
   DEMisDSM = 1;

const
   ResampleModeBoth = 1;
   ResampleModeHalfSec = 2;
   ResampleModeOneSec = 3;

const
   MeanParams : array[1..3] of shortstring = ('ELVD_MEAN','SLPD_MEAN','RUFD_MEAN');
   StdDevParams : array[1..3] of shortstring = ('ELVD_STD','SLPD_STD','RUFD_STD');
   MedianParams : array[1..3] of shortstring = ('ELVD_MED','SLPD_MED','RUFD_MED');

const
   NumTileCharacters = 7;
   TileCharacters : array[1..NumTileCharacters] of shortstring = ('AVG_ELEV','AVG_ROUGH','AVG_SLOPE','BARREN_PC','FOREST_PC','RELIEF','URBAN_PC');
   NCrits = 12;
   Crits : array[1..NCrits] of shortstring = ('ELEV_SSIM','RRI_SSIM','SLOPE_SSIM','HILL_SSIM','RUFF_SSIM','TPI_SSIM','ELEV_R2','SLOPE_R2','HILL_R2','RUFF_R2','TPI_R2','RRI_R2');
const
   RefDEMType : array[1..2] of shortstring = ('DSM','DTM');

   NumLandTypes = 8;
   LandTypes : array[1..NumLandTypes] of shortstring = ('ALL','FLAT','GENTLE','STEEP','CLIFF','URBAN','FOREST','BARREN');

   MaxDEMIXDEM = 10;

const
   NumDEMIXDEM : integer = 0;
var
   DEMIXDEMTypeName : array[1..MaxDEMIXDEM] of shortstring;   // = ('FABDEM','COP','ALOS','NASA','SRTM','ASTER');
   DEMIXshort : array[1..MaxDEMIXDEM] of shortstring;         // = ('FAB','COP','ALOS','NASA','SRTM','ASTER');


//service functions and procedures
   function LoadDEMIXReferenceDEMs(var RefDEM : integer; OpenMaps : boolean = true) : boolean;
   function LoadDEMIXCandidateDEMs(AreaName : ShortString; RefDEM : integer; OpenMaps : boolean = false; AllCandidates : boolean = true) : boolean;
   procedure GetReferenceDEMsForTestDEM(TestSeries : shortstring; var UseDSM,UseDTM : integer);
   function CriterionTieTolerance(Criterion : shortstring) : float32;
   procedure GetFilterAndHeader(i,j : integer; var aHeader,aFilter : shortString);
   function DEMIX_AreasWanted(AreaName : shortstring = '') : tStringList;
   function ShortTestAreaName(TestAreaName : shortstring) : shortstring;

   function GetAreaNameForDEMIXTile(DB : integer; DemixTile : shortstring) : shortstring;

   procedure FilterInSignedCriteria(DBonTable : integer);
   function CreateFilterOutSignedCriteria(DBonTable : integer) : shortstring;
   procedure FilterOutSignedCriteria(DBonTable : integer);

   function SymbolFromDEMName(DEMName : shortstring) : tFullSymbolDeclaration;
   function DEMIXColorFromDEMName(DEMName : shortstring) : tPlatformColor;
   function WhatTestDEMisThis(fName : PathStr) : shortstring;
   function DEMIXTestDEMLegend : tMyBitmap;

   procedure OpenDEMIXDatabaseForAnalysis;
   procedure GetDEMIXpaths(StartProcessing : boolean = true);
   procedure EndDEMIXProcessing;
   procedure LoadDEMIXnames;

   procedure AddCountryToDB(DB : integer);
   function MakeHistogramOfDifferenceDistribution(Tile,param,Ref : shortstring) : tThisBaseGraph;
   procedure SummarizeEGM96toEGM2008shifts;
   procedure SetDirtAirballBackground(var Result : tThisBaseGraph; DEMType : shortstring);   //brown dirtball for STM, blue airball for DSM

//3DEP reference DEM processing pipeline
   procedure BatchGDAL_3DEP_shift(DataDir : PathStr = '');
   procedure DEMIX_Create3DEPReferenceDEMs(DataDir : PathStr = '');
   procedure DEMIX_Merge3DEPReferenceDEMs(DataDir : PathStr = '');

//Other reference DEM processing pipeline
   procedure DEMIX_merge_source(Areas : tStringList = Nil);
   procedure DEMIX_CreateReferenceDEMs(Areas : tStringList = Nil);

//processing steps to create DEMIX data base
   procedure ComputeDEMIX_tile_stats(AreaName : shortstring = '');
   procedure CreateDEMIX_GIS_database(AreaName : shortstring = '');

//other processing steps
   procedure SequentialProcessAnArea;
   procedure DEMIXCreateHalfSecRefDEMs(AreaName : shortstring = '');
   procedure DEMIX_merge_Visioterra_source(AreaName : shortstring = '');

//DEMIX graphs
   procedure DEMIX_evaluations_graph(DBonTable : integer);
   procedure SlopeRoughnessWhiskerPlots(DBonTable : integer);
   function DEMIX_SSIM_R2_clusters_graph(DBonTable : integer) : tThisBaseGraph;
   procedure DEMIX_SSIM_R2_clusters_diversity_graphs(DBonTable : integer; ColorByDEM : boolean = true);
   function DEMIX_SSIM_R2_cluster_sensitivity_graph(DBonTable : integer) : tThisBaseGraph;
   function DEMIX_SSIM_R2_single_tile_graph(DBonTable : integer; tile : shortstring) :tThisBaseGraph;


//DEMIX SSIM/R2 database operations
   procedure DEMIX_SSIM_R2_transpose_kmeans_new_db(DBonTable : integer);
   procedure SwitchSSIMorR2Scoring(DBonTable : integer);
   procedure DEMIX_clusters_per_tile(DBonTable : integer);


procedure AddTileCharacteristics(DBonTable : integer);
procedure EvaluationRangeForCriterion(DBonTable : integer);

procedure LoadThisDEMIXTile(AreaName,TileName : shortstring);


   procedure ModeOfDifferenceDistributions;

//DEMIX wine contest procedures based on database
   function DEMIXwineContestScoresGraph(DBonTable : integer; XScalelabel : shortstring; MinHoriz : float32 = 0.5; MaxHoriz : float32 = 5.5) : tThisBaseGraph;
   procedure WinsAndTies(DBonTable : integer);
   procedure DEMIX_graph_best_in_Tile(DBonTable : integer; SortByArea : boolean);
   procedure DEMIXisCOPorALOSbetter(DBonTable : integer);
   procedure BestDEMSbyCategory(DBonTable : integer);
   procedure ModeSTDPlot(DBonTable : integer);
   procedure DEMIXMeanMedianModeHistograms(db : integer);

   procedure MultipleBestByParametersSortByValue(DBonTable,Option : integer; var DEMsTypeUsing,TilesUsing,LandTypesUsing,CandidateDEMsUsing,CriteriaUsing,TileParameters : tStringList; ByPointFilters : boolean = false);


//DEMIX wine contest procedures moved from DEMdatabase 9/14/2023
   procedure RankDEMS(DBonTable : integer; UseAll : boolean = false);
   procedure SumsOfRankDEMS(DBonTable : integer);
   procedure DEMIXwineContestCriterionGraph(What,DBonTable : integer; AreaList : tStringList = nil; CriteriaUsed : tStringList = nil; LandTypePresent : tStringList = nil; DEMsPresent : tStringList = nil);
   procedure DEMIXTileSummary(DBonTable : integer);
   procedure DEMIXtile_inventory(DBonTable : integer);
   procedure DEMIXMeanMedianHistograms(db : integer);


procedure DEMIX_COP_clusters_tile_stats(DBonTable : integer);



const
  opByCluster = 1;
  opByDEM = 2;


procedure MakeDBForParamStats(Option,DBonTable : integer);


   {$IfDef Old3DEP}
      procedure SubsetLargeUS3DEParea(DEM : integer = 0);
      procedure BatchSubset_3DEP_DEMs;
      procedure DEMIX_VDatum_shifts;
      procedure SummarizeVDatumShifts;
   {$EndIf}

   {$IfDef AllowEDTM}
      procedure ExtractEDTMforTestAreas;
   {$EndIf}

   {$IfDef OpenDEMIXAreaAndCompare}
      procedure OpenDEMIXArea(fName : PathStr = '');
   {$EndIf}

   {$IfDef OldDEMIXroutines}
      procedure TransposeDEMIXwinecontestGraph(DBonTable : integer);
   {$EndIf}


procedure ResampleForDEMIXOneSecDEMs(DEM : integer; OpenMap : boolean = false; OutPath : PathStr = ''; ResampleMode : byte = 1);


function IsDEMaDSMorDTM(DEMName : ShortString) : integer;
function DEMIXLoadRefDEMFromPath(AreaName : shortstring; LoadMap : boolean) : integer;

procedure ReinterpolateTestDEMtoHalfSec(var DEM : integer; OpenMap : boolean);

type
   tDEMIXindexes = array[1..MaxDEMIXDEM] of integer;

function DEMsinIndex(Index : tDEMIXindexes) : integer;

var
   RefDEMs,TestDEMs,
   UsingRefDEMs,
   RefSlopeMap,RefRuffMap,RefRRI,RefTPI,
   RefHillshade,TestHillshade,TestTPI,
   SlopeMap,TestRuffMap,TestRRI : tDEMIXindexes;

   //TestDEM : tDEMIXindexes;

   TestSeries : array[1..MaxDEMIXDEM] of shortstring;
   DEMIX_DB_v2,
   HalfSecRefDTM,HalfSecRefDSM,HalfSecDTM,HalfSecALOS,HalfSecCOP,
   DEMIXRefDEM,RefDTMpoint,RefDTMarea,RefDSMpoint,RefDSMarea, COPRefDTM, COPRefDSM : integer;

   DEMIX_Base_DB_Path,DEMIX_profile_test_dir,
   DEMIX_Ref_Source,DEMIX_Ref_Merge,DEMIX_Ref_1sec,DEMIX_Ref_1sec_v1,
   DEMIX_test_dems,DEMIX_Ref_Half_sec,
   DEMIX_GIS_dbName_v3,
   DEMIX_distrib_graph_dir,DEMIX_diff_maps_dir,DEMIX_3DEP_Dir,

   GeodeticFName, IceSatFName, LandCoverFName,
   LocalDatumAddFName,LocalDatumSubFName,RefDSMPointFName,RefDSMareaFName,RefDTMPointFName,RefDTMareaFName, COPRefDTMFName,COPRefDSMFName : PathStr;

   {$IfDef DEMIX_DB1}
      DEMIX_DB_v1 : integer;
      DEMIX_GIS_dbName_v1 : PathStr;
   {$EndIf}

implementation

uses
   Nevadia_Main,
   DEMstat,Make_grid,PetImage,PetImage_form,new_petmar_movie,DEMdatabase,PetDButils,Pick_several_dems,
   Geotiff, BaseMap, GDAL_tools, DEMIX_filter, DEMstringgrid,DEM_NLCD,
   DEMCoord,DEMMapf,DEMDef_routines,DEM_Manager,DEM_indexes,PetMath;

var
   vd_path,DEMIX_area_dbName_v2,DEMIX_data_base,DEMIX_diff_dist,DEMIX_area_lc100 : PathStr;
   DoHorizontalShift,
   ElevDiffHists : boolean;


function GetAreaNameForDEMIXTile(DB : integer; DemixTile : shortstring) : shortstring;
begin
   GISdb[DB].SaveFilterStatus;
   GISdb[DB].ApplyGISFilter('DEMIX_TILE=' + QuotedStr(DemixTile));
   if GISdb[DB].MyData.FiltRecsInDB > 0 then Result := GISdb[DB].MyData.GetFieldByNameAsString('AREA')
   else Result := '';
   GISdb[DB].RestoreFilterStatus;
end;


procedure GetAreaDEMNames(TestAreaName : shortstring);
begin
   RefDTMareaFName  := '';
   //COPRefDTMFName := '';       //not needed
   //COPRefDSMFName := '';       //not needed

   //unfortunately we have not been totally consistent with the file naming
   RefDTMPointFName := DEMIX_Ref_1sec + TestAreaName + '_ref_1sec_point.tif';
   if not FileExists(RefDTMPointFName) then RefDTMPointFName := DEMIX_Ref_1sec + TestAreaName + '_dtm_ref_1sec_point.tif';
   if not FileExists(RefDTMPointFName) then RefDTMPointFName := DEMIX_Ref_1sec + TestAreaName + '_dtm_1sec_point.tif';
   if not FileExists(RefDTMPointFName) then RefDTMPointFName := DEMIX_Ref_1sec + TestAreaName + '_1sec_point.tif';

   if FileExists(RefDTMPointFName) then begin
      RefDTMareaFName := StringReplace(RefDTMPointFName, 'point', 'area',[rfIgnoreCase]);
      RefDSMpointFName := StringReplace(RefDTMpointFName, 'dtm', 'dsm',[rfIgnoreCase]);
      RefDSMareaFName := StringReplace(RefDTMareaFName, 'dtm', 'dsm',[rfIgnoreCase]);
      if not FileExists(RefDSMPointFName) then RefDSMPointFName := '';
      if not FileExists(RefDSMareaFName) then RefDSMareaFName := '';
      COPRefDTMFName := StringReplace(RefDSMPointFName, '1sec', '1.5x1sec',[rfIgnoreCase]);
      COPRefDSMFName := StringReplace(COPRefDTMFName, 'dtm', 'dsm',[rfIgnoreCase]);
   end
   else begin
      RefDTMPointFName := '';
   end;
end;



procedure LoadThisDEMIXTile(AreaName,TileName : shortstring);
var
   RefDEM,i : integer;
begin
   GetDEMIXpaths(false);
   GetAreaDEMNames(AreaName);
   LoadDEMIXReferenceDEMs(RefDEM);
   UsingRefDEMs := RefDEMs;
   if LoadDEMIXCandidateDEMs(AreaName,RefDEM,true) then begin
   end;

   for I := 1 to MaxDEMIXDEM do begin
      if ValidDEM(TestDEMs[i]) then DEMGlb[TestDEMs[i]].SelectionMap.SubsetAndZoomMapFromGeographicBounds(DEMIXtileBoundingBox(TileName));
   end;

   for I := 1 to MaxDEMIXDEM do begin
      if ValidDEM(RefDEMs[i]) then DEMGlb[RefDEMs[i]].SelectionMap.SubsetAndZoomMapFromGeographicBounds(DEMIXtileBoundingBox(TileName));
   end;
(*

      for i := pred(WMDEM.MDIChildCount) downto 0 do begin
         if (WMDEM.MDIChildren[i] is tMapForm) then (WMDEM.MDIChildren[i] as TMapForm).SubsetAndZoomMapFromGeographicBounds(DEMIXtileBoundingBox(TileName));
      end;
   //end;
*)
end;



procedure AddTileCharacteristics(DBonTable : integer);
var
   theFields : tStringList;
   i : integer;
begin
   if not FileExists(GISdb[DBonTable].dbOpts.LinkTableName) then begin
      GISdb[DBonTable].dbOpts.LinkTableName := ProgramRootDir + 'demix\demix_tiles_characteristics.dbf';
      GISdb[DBonTable].dbOpts.LinkFieldThisDB := 'DEMIX_TILE';
      GISdb[DBonTable].dbOpts.LinkFieldOtherDB := 'DEMIX_TILE';
   end;

   GISDb[DBonTable].ClearGISFilter;
   GISDb[DBonTable].EmpSource.Enabled := false;
   ShowHourglassCursor;
   GISdb[DBonTable].ClearLinkTable(true);
   GISdb[DBonTable].LinkSecondaryTable(GISdb[DBonTable].dbOpts.LinkTableName);
   theFields := tStringList.Create;

   theFields.Add('LAT');
   theFields.Add('LONG');
   for I := 1 to NumTileCharacters do theFields.Add(TileCharacters[i]);

   //theFields.Add('AREA');
   GISdb[DBonTable].FillFieldsFromJoinedTable(TheFields,true);
   GISDb[DBonTable].ShowStatus;
end;


procedure SwitchSSIMorR2Scoring(DBonTable : integer);
//for 0-1 values with high score wins, reverses so low score wins
var
   i : integer;
   Eval : float32;
begin
   GISDb[DBonTable].ClearGISFilter;
   GISDb[DBonTable].EmpSource.Enabled := false;
   ShowHourglassCursor;
   while not GISDb[DBonTable].MyData.eof do begin
      GISDb[DBonTable].MyData.Edit;
      for I := 1 to NumDEMIXDEM do begin
         Eval := GISdb[DBonTable].MyData.GetFieldByNameAsFloat(DEMIXDEMTypeName[i]);
         GISDb[DBonTable].MyData.SetFieldByNameAsFloat(DEMIXDEMTypeName[i],1-Eval);
      end;
      GISDb[DBonTable].MyData.Next;
   end;
   GISDb[DBonTable].ShowStatus;
end;



procedure EvaluationRangeForCriterion(DBonTable : integer);
//adds field with the range between the best and worst evaluations
var
   i : integer;
   Eval,Max,Min : float32;
begin
   GISdb[DBonTable].AddFieldToDataBase(ftFloat,'EVAL_RANGE',12,6);
   GISDb[DBonTable].ClearGISFilter;
   GISDb[DBonTable].EmpSource.Enabled := false;
   ShowHourglassCursor;
   while not GISDb[DBonTable].MyData.eof do begin
      Max := -99e39;
      Min := 99e39;
      for I := 1 to NumDEMIXDEM do begin
         Eval := GISdb[DBonTable].MyData.GetFieldByNameAsFloat(DEMIXDEMTypeName[i]);
         PetMath.CompareValueToExtremes(Eval,Min,Max);
      end;
      GISDb[DBonTable].MyData.Edit;
      GISDb[DBonTable].MyData.SetFieldByNameAsFloat('EVAL_RANGE',Max-Min);
      GISDb[DBonTable].MyData.Next;
   end;
   GISDb[DBonTable].ShowStatus;
end;


procedure LoadDEMIXnames;
var
   table : tMyData;
   fName : PathStr;
begin
   if (NumDEMIXDEM = 0) then begin
      fName := ProgramRootDir + 'demix\demix_dems.dbf';
      Table := tMyData.Create(fName);
      Table.ApplyFilter('USE=' + QuotedStr('Y'));
      NumDEMIXDEM := 0;
      while not Table.eof do begin
         inc(NumDEMIXDEM);
         DEMIXDEMTypeName[NumDEMIXDEM] := Table.GetFieldByNameAsString('DEM_NAME');
         DEMIXshort[NumDEMIXDEM] := Table.GetFieldByNameAsString('DEMIXSHORT');
         Table.Next;
      end;
     Table.Destroy;
   end;
end;


procedure RemoveFilesThatDoNotHaveString(var Files : tStringList; What : shortstring);
var
   i : integer;
   fName : PathStr;
begin
   for i := pred(Files.Count) downto 0 do begin
      fName := Files.Strings[i];
      if (not StrUtils.AnsiContainsText(UpperCase(fname),What)) then Files.Delete(i);
   end;
end;

procedure RemoveFilesThatDoHaveString(var Files : tStringList; What : shortstring);
var
   i : integer;
   fName : PathStr;
begin
   for i := pred(Files.Count) downto 0 do begin
      fName := Files.Strings[i];
      if (StrUtils.AnsiContainsText(UpperCase(fname),What)) then Files.Delete(i);
   end;
end;


function DEMsinIndex(Index : tDEMIXindexes) : integer;
var
   i : integer;
begin
   Result := 0;
   for I := 1 to MaxDEMIXDEM do
      if ValidDEM(Index[i]) then
         inc(Result);
end;


function WhatTestDEMisThis(fName : PathStr) : shortstring;
var
   i : integer;
begin
   Result := '';
   fName := UpperCase(fName);
   for i := 1 to NumDEMIXDEM do begin
      if StrUtils.AnsiContainsText(fname,DEMIXDEMTypeName[i]) then begin
         Result := DEMIXDEMTypeName[i];
         exit;
      end;
   end;
end;

procedure FilterInSignedCriteria(DBonTable : integer);
var
   aFilter : ANSIstring;
   i : integer;
begin
    aFilter := '';
    for I := 1 to 3 do begin
       aFilter := AddOrIfNeeded(aFilter) + 'CRITERION=' + QuotedStr(MeanParams[i]);
       aFilter := AddOrIfNeeded(aFilter) + 'CRITERION=' + QuotedStr(MedianParams[i]);
    end;
    GISdb[DBOntable].ApplyGISFilter(aFilter);
    GISdb[DBonTable].ShowStatus;
end;


function CreateFilterOutSignedCriteria(DBonTable : integer) : shortstring;
var
   i : integer;
begin
    Result := '' ;
    for I := 1 to 3 do begin
       Result := AddAndIfNeeded(Result) + 'CRITERION<>' + QuotedStr(MeanParams[i]);
       Result := AddAndIfNeeded(Result) + 'CRITERION<>' + QuotedStr(MedianParams[i]);
    end;
    Result := '(' + Result + ')';
end;


procedure FilterOutSignedCriteria(DBonTable : integer);
begin
    GISdb[DBOntable].ApplyGISFilter(CreateFilterOutSignedCriteria(DBonTable));
    GISdb[DBonTable].ShowStatus;
end;



procedure ReinterpolateTestDEMtoHalfSec(var DEM : integer; OpenMap : boolean);
var
   HalfSec : integer;
   fName : PathStr;
   Spacing : float32;
begin
   if ValidDEM(DEM) then begin
      if (DEMGlb[DEM].DEMheader.DEMUsed = ArcSecDEM) and (abs(DEMGlb[DEM].DEMheader.DEMxSpacing - 0.5) < 0.001) and (abs(DEMGlb[DEM].DEMheader.DEMySpacing - 0.5) < 0.001) then begin
         {$If Defined(RecordHalfSec)} WriteLineToDebugFile(DEMGlb[DEM].AreaName + ' already half sec'); {$EndIf}
      end
      else begin
         fName := MDtempDir + DEMGlb[DEM].AreaName + '_0.5sec.dem';
         Spacing := 0.5;
         HalfSec := DEMGlb[DEM].ReinterpolateLatLongDEM(Spacing,fName);
         CloseSingleDEM(DEM);
         DEM := HalfSec;
         if OpenMap then CreateDEMSelectionMap(DEM,true,true,mtIHSReflect);
         {$If Defined(RecordHalfSec)} WriteLineToDebugFile(DEMGlb[DEM].AreaName + ' reinterpolated'); {$EndIf}
      end;
   end
   else begin
      {$If Defined(RecordHalfSec)} WriteLineToDebugFile('Invalid DEM=' + IntToStr(DEM) + ' in ReinterpolateTestDEMtoHalfSec'); {$EndIf}
   end;
end;


      procedure GetFilterAndHeader(i,j : integer; var aHeader,aFilter : shortString);
      var
         RefFilter : shortstring;
      begin
         RefFilter := ' AND REF_TYPE=' + QuotedStr(RefDEMType[i]) + ' AND LAND_TYPE=' + QuotedStr('ALL');
         case j of
            1 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile avg slope > 18%';
                  aFilter := 'AVG_SLOPE > 18' + RefFilter;
                end;
            2 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile avg slope < 18%';
                  aFilter := 'AVG_SLOPE < 18' + RefFilter;
                end;
            3 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile relief < 25m';
                  aFilter := 'RELIEF < 25' + RefFilter;
                end;
            4 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile relief > 500m';
                  aFilter := 'RELIEF > 500' + RefFilter;
                end;
            5 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile avg rough > 10%';
                  aFilter := 'AVG_ROUGH > 10' + RefFilter;
                end;
            6 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile avg rough < 5%';
                  aFilter := 'AVG_ROUGH < 5' + RefFilter;
                end;
            7 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile urban > 25%';
                  aFilter := 'URBAN_PC > 25' + RefFilter;
                end;
            8 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile forest > 50%';
                  aFilter := 'FOREST_PC > 50' + RefFilter;
                end;
            9 : begin
                  aHeader := RefDEMType[i] + ' ' + 'ALL pixels  Tile barren > 25%';
                  aFilter := 'BARREN_PC > 25' + RefFilter;
                end;
         end;
      end;



function DEMIXTestDEMLegend : tMyBitmap;
var
   i,Left,Top : integer;
begin
   CreateBitmap(Result,1500,250);
   LoadMyFontIntoWindowsFont(MDDef.LegendFont,Result.Canvas.Font);
   Left := 25;
   Top := 10;
   for i := 1 to NumDEMIXDEM do begin
      Result.Canvas.Pen.Color := ConvertPlatformColorToTColor(DEMIXColorFromDEMName(DEMIXDEMTypeName[i]));
      Result.Canvas.Brush.Color := Result.Canvas.Pen.Color;
      Result.Canvas.Brush.Style := bsSolid;
      Result.Canvas.Rectangle(Left,Top,Left + 15,Top + 15);
      Result.Canvas.Brush.Style := bsClear;
      Result.Canvas.TextOut(Left + 20,Top,DEMIXDEMTypeName[i]);
      Left := Left + 30 + Result.Canvas.TextWidth(DEMIXDEMTypeName[i]);
   end;
   PutBitmapInBox(Result);
end;



procedure SetDirtAirballBackground(var Result : tThisBaseGraph; DEMType : shortstring);
begin
    if (DEMtype = 'DSM') then Result.GraphDraw.GraphBackgroundColor := RGB(219,236,237)
    else Result.GraphDraw.GraphBackgroundColor := RGB(237,237,221);
end;


procedure GetDEMIXpaths(StartProcessing : boolean = true);
begin
   {$If Defined(RecordDEMIXStart)} WriteLineToDebugFile('GetDEMIXpaths in'); {$EndIf}
   if StartProcessing then begin
      HeavyDutyProcessing := true;
      WMdem.Color := clInactiveCaption;
      DEMIXProcessing := true;
   end;
   StopSplashing;
   LoadDEMIXnames;

   //settings that can be changed, but constant here for DB creation
      ElevDiffHists := true;
      DoHorizontalShift := false;

      MDDef.DEMIX_Full := 75;
      MDDef.SlopeFlatBoundary := 12.5;
      MDDef.SlopeGentleBoundary := 25;
      MDDef.SlopeSteepBoundary := 50;
      MDDef.LandTypePointsNeeded := 100;
      MDDef.RoughnessBox := 5;
      MDDef.AutoMergeStartDEM := true;
      MDdef.DefaultMapXSize := 800;
      MDdef.DefaultMapYSize := 800;
      MDDef.TitleLabelFont.Size := 24;
      MDDef.LegendFont.Size := 20;
   {$If Defined(RecordDEMIXStart)} WriteLineToDebugFile('GetDEMIXpaths point 2'); {$EndIf}

   DEMIX_Base_DB_Path := 'G:\wine_contest\';
   FindDriveWithPath(DEMIX_Base_DB_Path);
   {$If Defined(RecordDEMIXStart)} WriteLineToDebugFile('GetDEMIXpaths point 3'); {$EndIf}

   DEMIX_Ref_Source := DEMIX_Base_DB_Path + 'wine_contest_v2_ref_source\';
   DEMIX_Ref_Merge := DEMIX_Base_DB_Path + 'wine_contest_v2_ref_merge\';
   DEMIX_Ref_1sec := DEMIX_Base_DB_Path + 'wine_contest_v2_ref_1sec\';
   DEMIX_Ref_Half_sec := DEMIX_Base_DB_Path + 'wine_contest_v2_ref_0.5sec\';
   DEMIX_Ref_1sec_v1 := DEMIX_Base_DB_Path + 'demix_reference_dems_v1\';
   vd_path := DEMIX_Base_DB_Path + 'wine_contest_v2_vdatum\';
   DEMIXresultsDir := DEMIX_Base_DB_Path + 'wine_contest_v2_tile_stats\';
   DEMIX_test_dems := DEMIX_Base_DB_Path + 'wine_contest_v2_test_dems\';
   DEMIXSettingsDir := DEMIX_Base_DB_Path + 'wine_contest_settings\';
   DEMIX_diff_dist  := DEMIX_Base_DB_Path + 'wine_contest_v2_diff_dist\';
   DEMIX_diff_maps_dir  := DEMIX_Base_DB_Path + 'wine_contest_difference_maps\';
   DEMIXSettingsDir := ProgramRootDir + 'demix\';
   DEMIX_area_lc100  := DEMIX_Base_DB_Path + 'wine_contest_v2_lc100\';
   DEMIX_profile_test_dir := DEMIX_Base_DB_Path + 'wine_contest_v2_topo_profiles\';
   DEMIX_distrib_graph_dir := DEMIX_Base_DB_Path + 'wine_contest_v2_difference_distrib_graphs\';
   DEMIX_3DEP_Dir := DEMIX_Base_DB_Path + 'wine_contest_v2_3dep\';

   //DEMIX_area_dbName_v2 := DEMIX_Base_DB_Path + 'wine_contest_v2_ref_source\demix_area_vert_datums.dbf';
   DEMIX_area_dbName_v2 := ProgramRootDir + 'demix\demix_test_areas_v3.dbf';

   DEMIX_GIS_dbName_v3 := DEMIX_Base_DB_Path + 'wine_contest_database\demix_gis_db_v2.5.dbf';
   //DEMIX_GIS_dbName_v1 := DEMIX_Base_DB_Path + 'wine_contest_database\demix_database_v1.dbf';
   {$If Defined(RecordDEMIXStart)} WriteLineToDebugFile('GetDEMIXpaths point 4'); {$EndIf}

   Geoid2008FName := 'g:\geoid\egm2008-1-vdatum.tif';
   FindDriveWithFile(Geoid2008FName);
   GeoidDiffFName := 'g:\geoid\egm96_to_egm2008.tif';
   FindDriveWithFile(GeoidDiffFName);
   {$If Defined(RecordDEMIXStart)} WriteLineToDebugFile('GetDEMIXpaths out'); {$EndIf}
end;


procedure EndDEMIXProcessing;
begin
   HeavyDutyProcessing := false;
   DEMIXProcessing := false;
   WMdem.Color := clScrollBar;
   wmdem.ClearStatusBarPanelText;
   ShowDefaultCursor;
end;


function DEMIXLoadRefDEMFromPath(AreaName : shortstring; LoadMap : boolean) : integer;
var
   FilesWanted : tStringList;
   j : integer;
   fName : PathStr;
begin
   FilesWanted := tStringList.Create;
   FindMatchingFiles(DEMIX_Ref_1sec,'*.tif',FilesWanted,1);
   for j := 0 to pred(FilesWanted.Count) do begin
      fName := FilesWanted.Strings[j];
      if StrUtils.AnsiContainsText(UpperCase(fname),UpperCase(AreaName)) then begin
         Result := OpenNewDEM(fName,LoadMap);
         exit;
      end;
   end;
   FilesWanted.Free;
end;


function ShortTestAreaName(TestAreaName : shortstring) : shortstring;
begin
   Result := StringReplace(TestAreaName,'_dtm','',[rfReplaceAll, rfIgnoreCase]);
   Result := StringReplace(Result,'_dsm','',[rfReplaceAll, rfIgnoreCase]);
end;


function DEMIX_AreasWanted(AreaName : shortstring = '') : tStringList;
var
   aTable : tMyData;
   PickedNum : integer;
begin
   if (AreaName = '') then begin
      aTable := tMyData.Create(DEMIX_area_dbName_v2);
      Result := aTable.UniqueEntriesInDB('AREA');
      aTable.Destroy;
      GetFromListZeroBased('DEMIX test areas to process',PickedNum,Result,false,true);
   end
   else begin
      Result := tStringList.Create;
      Result.Add(AreaName);
   end;
end;


procedure DEMIXCreateHalfSecRefDEMs(AreaName : shortstring = '');
var
   fName : PathStr;
   ErrorLog,Areas : tStringList;
   i,WantedDEM : integer;
   TStr : shortstring;
begin
   {$If Defined(RecordDEMIX)} WriteLineToDebugFile('DEMIXCreateHalfSecRefDEMs in'); {$EndIf}
   try
      GetDEMIXPaths;
      Areas := tStringList.Create;
      ErrorLog := tStringList.Create;
      Areas := DEMIX_AreasWanted(AreaName);
      if (Areas.Count > 0) then begin
        for i := 0 to pred(Areas.Count) do begin
           AreaName := Areas.Strings[i];
           wmdem.SetPanelText(2, 'Area: ' + IntToStr(succ(i)) + '/' + IntToStr(Areas.Count));
           wmdem.SetPanelText(3, AreaName);
           {$If Defined(RecordDEMIX)} HighlightLineToDebugFile('DEMIXreferenceDEMs for ' + AreaName); {$EndIf}
           fName := DEMIX_Ref_Half_sec + AreaName + '_ref_0.5sec.tif';
           if not FileExists(fName) then begin
              fName := DEMIX_Ref_Merge + AreaName + '.dem';
              if FileExists(fName) then begin
                 WantedDEM := OpenNewDEM(fName,true);   //need to open map to create the subset
                 if (DEMGlb[WantedDEM].DEMheader.VerticalCSTypeGeoKey = VertCSEGM2008) then begin
                    {$If Defined(RecordDEMIX)} WriteLineToDebugFile('Call ResampleForDEMIXOneSecDEMs ' + AreaName); {$EndIf}
                    ResampleForDEMIXOneSecDEMs(WantedDEM,false,DEMIX_Ref_1sec,ResampleModeHalfSec);
                 end
                 else begin
                    TStr := DEMGlb[WantedDEM].AreaName  + ' not EGM2008; vert datum=' + IntToStr(DEMGlb[WantedDEM].DEMheader.VerticalCSTypeGeoKey);
                    if AnswerIsYes(TStr + '  Proceed anyway') then begin
                       ResampleForDEMIXOneSecDEMs(WantedDEM,false,DEMIX_Ref_1sec,ResampleModeHalfSec);
                    end
                    else begin
                       {$If Defined(RecordDEMIX)} WriteLineToDebugFile(TStr); {$EndIf}
                       ErrorLog.Add(TStr);
                    end;
                 end;
                 CloseSingleDEM(WantedDEM);
              end
              else begin
                 TStr := AreaName  + ' no merged source DEMs';
                 {$If Defined(RecordDEMIX)} WriteLineToDebugFile(TStr); {$EndIf}
                 ErrorLog.Add(TStr);
              end;
           end;
        end;
      end
      else begin
          {$If Defined(RecordDEMIX)} WriteLineToDebugFile('DEMIXreferenceDEMs, no areas ' + DEMIX_Ref_Merge); {$EndIf}
      end;
   finally
      Areas.Free;
      EndDEMIXProcessing;
      DisplayAndPurgeStringList(ErrorLog,'DEMIXCreateHalfSecRefDEMs Problems');
   end;
   {$If Defined(RecordDEMIX)} WriteLineToDebugFile('DEMIXCreateHalfSecRefDEMs out'); {$EndIf}
end;


procedure AddCountryToDB(DB : integer);
var
   Table : tMyData;
   Area,Country : shortstring;
   i : integer;
begin
   GetDEMIXPaths;
   Table := tMyData.Create(DEMIX_area_dbName_v2);
   GISdb[db].AddFieldToDatabase(ftString,'COUNTRY',16);
   i := 0;
   while not Table.eof do begin
      inc(i);
      GISdb[db].EmpSource.Enabled := false;
      Country := Table.GetFieldByNameAsString('COUNTRY');
      Area := Table.GetFieldByNameAsString('AREA');
      wmdem.SetPanelText(2, 'Area: ' + IntToStr(succ(i)) + '/' + IntToStr(Table.FiltRecsInDB) + ' ' + Area);
      if StrUtils.AnsiContainsText(UpperCase(Area),'_DSM') then begin

      end
      else begin
         Area := ShortTestAreaName(Area);
         GISdb[db].ApplyGISFilter('AREA=' + QuotedStr(Area));
         GISdb[db].FillFieldWithValue('COUNTRY',Country);
      end;
      Table.Next;
   end;
   Table.Destroy;
   wmdem.SetPanelText(2,'');
   GISdb[db].ClearGISFilter;
   GISdb[db].ShowStatus;
end;




procedure SummarizeEGM96toEGM2008shifts;
var
   Files,Summary : tStringList;
   i,DEM,Geoid : integer;
   TStr : shortstring;
   fName : PathStr;

   procedure AddPoint(col,row : integer);
   var
      Lat,Long : float64;
      z : float32;
   begin
      DEMglb[DEM].DEMGridToLatLongDegree(Col,Row,Lat,Long);
      DEMGlb[Geoid].GetElevFromLatLongDegree(Lat,Long,z);
      TStr := Tstr + ',' + RealToString(z,-12,-2);
   end;

begin
   GetDEMIXpaths(false);
   Geoid := OpenNewDEM(GeoidDiffFName,false);

   Summary := tstringlist.create;
   Summary.Add('AREA,SHIFT_NW,SHIFT_NE,SHIFT_CENT,SHIFT_SE,SHIFT_SW');
   Files := nil;
   Petmar.FindMatchingFiles(DEMIX_Ref_Half_sec,'*.tif',Files,0);
   StartProgress('EGM96 shift summary');
   for i := 0 to pred(Files.Count) do begin
      UpdateProgressbar(i/Files.Count);
      fName := Files.Strings[i];
      if StrUtils.AnsiContainsText(UpperCase(fname),'_DSM') then begin
      end
      else begin
         DEM := OpenNewDEM(fName,false);
         TStr := ExtractFileNameNoExt(fName);
         AddPoint(DEMglb[DEM].DEMHeader.NumRow,0);
         AddPoint(DEMglb[DEM].DEMHeader.NumRow,DEMglb[DEM].DEMHeader.NumCol);
         AddPoint(DEMglb[DEM].DEMHeader.NumRow div 2,DEMglb[DEM].DEMHeader.NumCol div 2);
         AddPoint(0,0);
         AddPoint(DEMglb[DEM].DEMHeader.NumCol,0);
         Summary.Add(TStr);
         CloseSingleDEM(DEM);
      end;
   end;
   CloseAllDEMs;
   Files.Destroy;
   EndProgress;
   fName := NextFileNumber(MDTempDir,'EGM96_shift_summary','.dbf');
   StringList2CSVtoDB(Summary,fName);
end;



procedure SequentialProcessAnArea;
//still in progress, 20 May 2023
var
   Areas : tStringList;
   i : integer;
   AreaName : shortstring;
begin
(*
   GetDEMIXpaths(true);
   Areas := DEMIX_AreasWanted;
   try
      for i := 0 to pred(Areas.Count) do begin
         AreaName := Areas.Strings[i];
         DEMIX_merge_source(AreaName);
         //DEMIX_VDatum_shifts(Areas.Strings[i]);
         DEMIX_CreateReferenceDEMs(AreaName);
         ComputeDEMIX_tile_stats(AreaName);
         CreateDEMIX_GIS_database(AreaName);
      end;
   finally
      EndDEMIXProcessing;
   end;
*)
end;


function IsDEMaDSMorDTM(DEMName : ShortString) : integer;
//works for the DEMIX naming conventions, where DSM must have that in the file name
begin
   if (StrUtils.AnsiContainsText(UpperCase(DEMName),'DSM')) then Result := DEMisDSM
   else Result := DEMisDTM;
end;


procedure OpenDEMIXDatabaseForAnalysis;
begin
   GetDEMIXpaths(false);
   if not FileExists(DEMIX_GIS_dbName_v3) then Petmar.GetExistingFileName('DEMIX db version 3','*.dbf',DEMIX_GIS_dbName_v3);
   {$IfDef DEMIX_DB1} if not FileExists(DEMIX_GIS_dbName_v1) then Petmar.GetExistingFileName('DEMIX db version 1','*.dbf',DEMIX_GIS_dbName_v1); {$EndIf}
   OpenNumberedGISDataBase(DEMIX_DB_v2,DEMIX_GIS_dbName_v3,false);
   GISdb[DEMIX_DB_v2].LayerIsOn := false;
   {$IfDef DEMIX_DB1}
      OpenNumberedGISDataBase(DEMIX_DB_v1,DEMIX_GIS_dbName_v1,false);
      GISdb[DEMIX_DB_v1].LayerIsOn := false;
   {$EndIf}
   DoDEMIXFilter(DEMIX_DB_v2);
end;


function CriterionTieTolerance(Criterion : shortstring) : float32;
var
    TieToleranceTable : tMyData;
begin
   TieToleranceTable := tMyData.Create(MDDef.DEMIX_criterion_tolerance_fName);
   TieToleranceTable.ApplyFilter('CRITERION=' + QuotedStr(Criterion));
   Result := TieToleranceTable.GetFieldByNameAsFloat('TOLERANCE');
   TieToleranceTable.Destroy;
end;


procedure DEMIXisCOPorALOSbetter(DBonTable : integer);
var
   RefFilter : shortstring;
   Compare,i,j,Opinions,db : integer;
   fName : PathStr;
   Findings,Criteria,DEMs : tStringList;


   procedure DoOne(Header,theFilter : shortstring);
   var
      Cop,ALOS,FAB,dem : integer;
      aLine : shortString;
      Counts : array[0..10] of integer;
   begin
      {$If Defined(RecordDEMIXFull)} WriteLineToDebugFile('DO-ONE  ' + theFilter); {$EndIf}
      WMDEM.SetPanelText(1,theFilter);
      GISdb[DBonTable].ApplyGISFilter(theFilter);
      GISdb[DBonTable].EmpSource.Enabled := false;
      Opinions := GISdb[DBonTable].MyData.FiltRecsInDB;
      if (Opinions >= 10) then begin
         if (Compare = 1) then begin
            GISdb[DBonTable].ApplyGISFilter(theFilter + ' AND COP_ALOS=' + QuotedStr('tie'));
            GISdb[DBonTable].ApplyGISFilter(theFilter + ' AND COP_ALOS=' + QuotedStr('alos'));
            ALOS := GISdb[DBonTable].MyData.FiltRecsInDB;
            GISdb[DBonTable].ApplyGISFilter(theFilter + ' AND COP_ALOS=' + QuotedStr('cop'));
            COP := GISdb[DBonTable].MyData.FiltRecsInDB;
            Findings.Add(Header + '  (n=' + IntToStr(Opinions) + '),' + RealToString(100.0 * alos/opinions,-8,-2)+ ','  + RealToString(100.0 * cop/opinions,-8,-2));
         end
         else if (Compare = 2) then begin
            GISdb[DBonTable].ApplyGISFilter(theFilter + ' AND DEM_LOW_SC=' + QuotedStr('alos'));
            ALOS := GISdb[DBonTable].MyData.FiltRecsInDB;
            GISdb[DBonTable].ApplyGISFilter(theFilter + ' AND DEM_LOW_SC=' + QuotedStr('cop'));
            COP := GISdb[DBonTable].MyData.FiltRecsInDB;
            GISdb[DBonTable].ApplyGISFilter(theFilter + ' AND DEM_LOW_SC=' + QuotedStr('fabdem'));
            FAB := GISdb[DBonTable].MyData.FiltRecsInDB;
            Findings.Add(Header + '  (n=' + IntToStr(Opinions) + '),' + RealToString(100.0 * alos/opinions,-8,-2) + ',' + RealToString(100.0 * cop/opinions,-8,-2) + ',' + RealToString(100.0 * fab/opinions,-8,-2));
         end
         else begin
            GISdb[DBonTable].MyData.First;
            for DEM := 0 to 10 do Counts[DEM] := 0;
            while not GISdb[DBonTable].MyData.EOF do begin
               aLine := GISdb[DBonTable].MyData.GetFieldByNameAsString('DEM_LOW_SC');
               for DEM := 0 to pred(DEMs.Count) do
                  if StrUtils.AnsiContainsText(aline,DEMs.Strings[DEM]) then inc(Counts[DEM]);
               GISdb[DBonTable].MyData.Next;
            end;
            aline := Header + '  (n=' + IntToStr(Opinions) + ')';
            for DEM := 0 to pred(DEMs.Count) do aline := aline + ',' + RealToString(100.0 * Counts[DEM]/opinions,-8,-2);
            Findings.Add(aLine);
         end;
      end;
   end;


var
   aHeader,aFilter,TStr : shortstring;
   n : integer;
begin
   {$If Defined(RecordDEMIX)} WriteLineToDebugFile('DEMIXisCOPorALOSbetter in'); {$EndIf}
   try
      GISdb[DBonTable].ApplyGISFilter('');
      ShowHourglassCursor;
      Criteria := GISdb[DBonTable].MyData.UniqueEntriesInDB('CRITERION');
      DEMs := tStringList.Create;
      DEMs.LoadFromFile(DEMIXSettingsDir + 'demix_dems.txt');

      for Compare := 1 to 3 do begin
         for i := 1 to 2 do begin
            {$If Defined(RecordDEMIX)} HighlightLineToDebugFile('DEMIXisCOPorALOSbetter start ' + RefDEMType[i]); {$EndIf}
            ShowHourglassCursor;
            Findings := tStringList.Create;
            if (Compare = 1) then Findings.Add('FILTER,ALOS,COP')
            else if (Compare = 2) then Findings.Add('FILTER,ALOS,COP,FABDEM')
            else begin
               TStr := 'FILTER';
               for j := 0 to pred(DEMs.Count) do Tstr := Tstr + ',' + DEMs.Strings[j];
               Findings.Add(TStr);
            end;

            RefFilter := ' AND REF_TYPE=' + QuotedStr(RefDEMType[i]);
            for j := 1 to NumLandTypes do begin
               DoOne(RefDEMType[i] + ' ' + LandTypes[j] + ' pixels','LAND_TYPE=' + QuotedStr(LandTypes[j]) + RefFilter);
            end;
            Findings.Add('SKIP');

            if GISdb[DBonTable].MyData.FieldExists('PC_BARREN') then n := 9 else n := 8;
            for j := 1 to n do begin
               GetFilterAndHeader(i,j,aHeader,aFilter);
               DoOne(aHeader,aFilter);
            end;

            Findings.Add('SKIP');
            for j := 0 to pred(Criteria.Count) do begin
               DoOne(RefDEMType[i] + ' ALL pixels  ' + Criteria.Strings[j],'CRITERION=' + QuotedStr(Criteria.Strings[j]) + RefFilter );
            end;
            if Compare = 1 then TStr := '_cop_or_alos_'
            else if Compare = 2 then TStr := '_fab_cop_or_alos_'
            else TStr := '_share_first_';

            fName := NextFileNumber(MDTempDir,RefDEMType[i] + TStr,'.dbf');
            db := StringList2CSVtoDB(Findings,fName);
            if (Compare = 1) then TStr := 'COP or ALOS Winning Percentage'
            else if (Compare = 2) then TStr := 'COP or ALOS or FABDEM Winning Percentage'
            else TStr := 'DEM share of First Place';
            DEMIXwineContestScoresGraph(DB,Tstr + ' (%)',0,100);
         end;
      end;
   finally
      Criteria.Destroy;
      GISdb[DBonTable].ApplyGISFilter('');
      GISdb[DBonTable].ShowStatus;
   end;
   {$If Defined(RecordDEMIX)} WriteLineToDebugFile('DEMIXisCOPorALOSbetter out'); {$EndIf}
end;



procedure WinsAndTies(DBonTable : integer);
const
    nDEMs = 7;
    nT = 6;
    TheDEMs : array[1..NDEMs] of shortstring = ('TIES','ALOS_TIE','COP_TIE','FABDEM_TIE','NASA_TIE','SRTM_TIE','ASTER_TIE');
var
   Results : tStringList;
   aFilter : shortstring;


   procedure DoOne(ParameterList : tStringList; FilterField : shortstring);
   var
      Findings : array[1..nDEMs,1..nDEMs] of integer;
      i,j,k,DEM : integer;
   begin
      for DEM := 1 to 2 do begin
         wmdem.SetPanelText(2,RefDEMType[DEM]);
         for k := 1 to ParameterList.Count do begin
            wmdem.SetPanelText(3,ParameterList.Strings[pred(k)]);
            {$IfDef RecordDEMIX} HighlightLineToDebugFile('WinsAndTies, k=' + IntToStr(k)); {$EndIf}

            for i := 1 to nDEMs do begin
               for j := 2 to nDEMs do begin
                  Findings[i,j] := 0;
               end;
            end;

            for i := 1 to nDEMs do begin
               for j := 1 to nT do begin
                  aFilter := TheDEMs[i] + '=' + IntToStr(j)  +  ' AND REF_TYPE=' + QuotedStr(RefDEMType[DEM]);
                  if (k > 1) then aFilter :=  aFilter + ' AND ' + FilterField + '=' + QuotedStr(ParameterList.Strings[pred(k)]);
                  GISdb[DBonTable].ApplyGISfilter(aFilter);
                  Findings[i,j] := GISdb[DBonTable].MyData.FiltRecsInDB;
               end;
            end;

            for j := 1 to nT do begin
               aFilter := ParameterList.Strings[pred(k)] + ',' + RefDEMType[DEM] + ',' + IntToStr(j);
               for i := 1 to nDEMs do begin
                  aFilter := aFilter + ',' + {IntToStr(nT) + ',' +} IntToStr(Findings[i,j]);
               end;
               Results.Add(afilter);
            end;
         end;
      end;
   end;

const
   nParams = 4;
   TheLumpedParams : array[1..NParams] of shortstring = ('*','ELVD','SLPD','RUFD');
var
   fName : PathStr;
   theParams : tstringlist;
   j : integer;
begin
   {$IfDef RecordDEMIX} HighlightLineToDebugFile('WinsAndTies in'); {$EndIf}
   try
      if not GISdb[DBonTable].MyData.FieldExists('COP_TIE') then GISdb[DBonTable].dbTablef.iesbyopinions1Click(Nil);
      GetDEMIXPaths(true);

      GISdb[DBonTable].EmpSource.Enabled := false;

      Results := tStringList.Create;
      aFilter := 'PARAMETER,REF_TYPE,NUM_TIES';
      for j := 1 to nDEMs do aFilter :=  aFilter + ',' + TheDEMs[j];
      Results.Add(aFilter);
      theParams := tstringlist.Create;
      for j := 1 to nParams do TheParams.Add(TheLumpedParams[j]);
      DoOne(TheParams,'CRIT_CAT');
      TheParams.Clear;
      TheParams.LoadFromFile(DEMIXSettingsDir + 'criteria_all.txt');
      DoOne(TheParams,'CRITERION');
      TheParams.Destroy;

      {$IfDef RecordDEMIX} HighlightLineToDebugFile('WinsAndTies, make db'); {$EndIf}
      fName := NextFileNumber(MDTempDir,MDTempDir + 'wins_and_ties_','.dbf');
      StringList2CSVtoDB(Results,fName);
   finally
      GISdb[DBonTable].ClearGISfilter;
      GISdb[DBonTable].ShowStatus;
      EndDEMIXProcessing;
   end;
end;


function DEMIXColorFromDEMName(DEMName : shortstring) : tPlatformColor;
begin
   DEMName := UpperCase(DEMName);
   if DEMName = 'TIE' then Result := claBrown
   else if DEMName = 'ALOS' then Result := RGBtrip(230,159,0)
   else if DEMName = 'ASTER' then Result := RGBtrip(0,114,178)
   else if DEMName = 'COP' then Result := RGBtrip(86,180,233)
   else if DEMName = 'FABDEM' then Result := RGBtrip(204,121,167)
   else if DEMName = 'NASA' then Result := RGBtrip(0,158,115)
   else if DEMName = 'SRTM' then Result := RGBtrip(213,94,0)
   else if DEMName = 'EDTM' then Result := RGBtrip(115,43,245);
end;


function SymbolFromDEMName(DEMName : shortstring) : tFullSymbolDeclaration;
begin
   Result.Size := 4;
   Result.Color := DEMIXColorFromDEMName(DEMName);
   Result.DrawingSymbol := FilledBox;
end;


procedure GetReferenceDEMsForTestDEM(TestSeries : shortstring; var UseDSM,UseDTM : integer);
begin
   if StrUtils.AnsiContainsText(TestSeries,'ALOS') or StrUtils.AnsiContainsText(TestSeries,'AW3D') then begin
      UseDTM := RefDTMArea;
      UseDSM := RefDSMArea;
   end
   else if StrUtils.AnsiContainsText(TestSeries,'COP') then begin
      if (COPRefDTM <> 0) then UseDTM := COPRefDTM else UseDTM := RefDTMpoint;
      if (COPRefDSM <> 0) then UseDSM := COPRefDSM else UseDSM := RefDSMpoint;
   end
   else begin
      UseDTM := RefDTMPoint;
      UseDSM := RefDSMPoint;
   end;
end;



procedure DoDEMIX_DifferenceMaps(AreaName,ShortName,LongName : shortString; var Graph1,Graph2 : tThisBaseGraph);
var
   TestGrid,DSMgrid,DTMGrid,
   i,UseDSM,UseDTM : integer;
   Min,Max,BinSize : float32;
   DSMElevFiles,DSMLegendFiles,DTMElevFiles,DTMLegendFiles : tStringList;


      procedure ModifyGraph(Graph : tThisBaseGraph);
      var
         I : integer;
      begin
         for I := 1 to Graph.GraphDraw.LegendList.Count do begin
            Graph.GraphDraw.FileColors256[i] := DEMIXColorFromDEMName(Graph.GraphDraw.LegendList[pred(i)]);
         end;
         Graph.RedrawDiagram11Click(Nil);
         Graph.Image1.Canvas.Draw(Graph.GraphDraw.LeftMargin+15,Graph.GraphDraw.TopMargin+10,Graph.MakeLegend(Graph.GraphDraw.LegendList,false));
      end;


     procedure MakeDifferenceGrid(RefGrid : integer; RefType : shortstring; LegendFiles,ElevFiles : tStringList);

            function SaveValuesFromGrid(DEM : integer; What : shortstring) : ShortString;
            var
               Col,Row,Npts :integer;
               zs : ^bfarray32;
               z : float32;
            begin
               New(ZS);
               NPts := 0;
               for Col := 0 to pred(DEMGlb[DEM].DEMHeader.NumCol) do begin
                  for Row := 0 to pred(DEMGlb[DEM].DEMHeader.NumRow) do begin
                     if DEMGlb[DEM].GetElevMetersOnGrid(col,row,z) then begin
                       zs^[Npts] := z;
                       inc(NPts);
                     end;
                  end;
               end;

               if (NPts > 0) then begin
                  Result := DEMIXtempfiles + DEMGlb[DEM].AreaName + '_' + AreaName + '.z';
                  SaveSingleValueSeries(npts,zs^,Result);
               end;
               Dispose(zs);
            end;

     var
        DiffGrid : integer;
        fName : PathStr;
     begin
         DiffGrid := MakeDifferenceMap(RefGrid,TestGrid,RefGrid,0,true,false,false);
         DEMglb[DiffGrid].AreaName := AreaName + '_' + TestSeries[i] + '_' + ShortName + '_' + RefType;
         fName := DEMIXtempfiles + DEMglb[DiffGrid].AreaName + '.dem';
         DEMglb[DiffGrid].WriteNewFormatDEM(fName);
         ElevFiles.Add(SaveValuesFromGrid(DiffGrid,ShortName + '_' + RefType + '_'));
         LegendFiles.Add(TestSeries[i]);
         CloseSingleDEM(DiffGrid);
         if (ShortName <> 'elvd') then begin
            fName := AreaName + '_percent_diff_' + TestSeries[i] + '_' + ShortName + '_' + RefType;
            DiffGrid := PercentDifferentTwoGrids(RefGrid,TestGrid,fName);
            fName := DEMIXtempfiles + fName + '.dem';
            DEMglb[DiffGrid].WriteNewFormatDEM(fName);
            CloseSingleDEM(RefGrid);
         end;
     end;



begin
   {$IfDef RecordDEMIX} HighlightLineToDebugFile('start differences ' + LongName); {$EndIf}
   MDDef.DefaultGraphXSize := 1000;
   MDDef.DefaultGraphYSize := 600;
   DTMElevFiles := tStringList.Create;
   DTMLegendFiles := tStringList.Create;
   DSMElevFiles := tStringList.Create;
   DSMLegendFiles := tStringList.Create;

   for I := 1 to MaxDEMIXDEM do begin
      if ValidDEM(TestDEMs[i]) then begin
         GetReferenceDEMsForTestDEM(TestSeries[i],UseDSM,UseDTM);

         if (ShortName = 'elvd') then begin
            TestGrid := TestDEMs[i];
            DTMGrid := UseDTM;
         end;
         if (ShortName = 'slpd') then begin
            TestGrid := CreateSlopeMap(TestDEMs[i]);
            DTMGrid := CreateSlopeMap(UseDTM);
         end;
         if (ShortName = 'rufd') then begin
            TestGrid := CreateRoughnessSlopeStandardDeviationMap(TestDEMs[i],3);
            DTMGrid := CreateRoughnessSlopeStandardDeviationMap(UseDTM,3);
         end;

         {$IfDef RecordDEMIX} writeLineToDebugFile(Testseries[i] + ' DTMs ' + DEMGlb[DTMgrid].AreaName + '  ' + DEMGlb[Testgrid].AreaName + ' ' + IntToStr(DTMGrid) + '/' + IntToStr(TestGrid)); {$EndIf}

         MakeDifferenceGrid(DTMGrid,'dtm',DTMLegendFiles,DTMElevFiles);

         if (UseDSM <> 0) then begin
            if (ShortName = 'elvd') then begin
               DSMGrid := UseDSM;
            end;
            if (ShortName = 'slpd') then begin
               DSMGrid := CreateSlopeMap(UseDSM);
            end;
            if (ShortName = 'rufd') then begin
               DSMGrid := CreateRoughnessSlopeStandardDeviationMap(UseDSM,3);
            end;
            {$IfDef RecordDEMIX} writeLineToDebugFile(Testseries[i] + ' DSMs ' + DEMGlb[DSMgrid].AreaName + '  ' + DEMGlb[Testgrid].AreaName + ' ' + IntToStr(DSMGrid) + '/' + IntToStr(TestGrid)); {$EndIf}
            MakeDifferenceGrid(DSMGrid,'dsm',DSMLegendFiles,DSMElevFiles);
         end;
         if (ShortName <> 'elvd') then CloseSingleDEM(Testgrid);
         {$IfDef RecordDEMIX} WriteLineToDebugFile('After ' + TestSeries[i] + ', Open grids now=' + IntToStr(NumDEMDataSetsOpen) ); {$EndIf}
      end;
   end;
   {$IfDef RecordDEMIX} WriteLineToDebugFile('start graphs'); {$EndIf}

   if (ShortName = 'elvd') then begin
      Min := -50;
      Max := 50;
      BinSize := 0.25;
   end
   else if (ShortName = 'slpd') then begin
      Min := -50;
      Max := 50;
      BinSize := 0.25;
   end
   else if (ShortName = 'rufd') then begin
      Min := -20;
      Max := 20;
      BinSize := 0.15;
   end;

   Graph1 := CreateMultipleHistogram(MDDef.CountHistograms,DTMElevFiles,DTMLegendFiles,AreaName + ' DTM ' + LongName + ' difference','DTM ' + LongName + ' difference distribution',100,Min,Max,BinSize);
   ModifyGraph(Graph1);
   if (DSMElevFiles.Count > 0) then begin
      Graph2 := CreateMultipleHistogram(MDDef.CountHistograms,DSMElevFiles,DSMLegendFiles,AreaName + ' DSM ' + LongName + ' difference','DSM ' + LongName + ' difference distribution',100,Min,Max,BinSize);
      ModifyGraph(Graph2);
   end
   else begin
      Graph2 := Nil;
   end;
   {$IfDef RecordDEMIX} writeLineToDebugFile('done differences'); {$EndIf}
end;


function LoadDEMIXCandidateDEMs(AreaName : ShortString; RefDEM : integer; OpenMaps : boolean = false; AllCandidates : boolean = true) : boolean;
var
   {$IfDef RecordDEMIX} AllDEMs, {$EndIf}
   WantSeries,ShortName : shortstring;
   IndexSeriesTable : tMyData;
   NumPts : int64;
   WantDEM,WantImage,Ser,i,GeoidGrid : integer;
   fName,SaveName : Pathstr;


         procedure MoveFromEGM96toEGM2008(var DEM : integer);
         //Reproject vertical datum to EGM2008 if required because DEM is EGM96
         var
           Col,Row,NewDEM : integer;
           z,z2 : float32;
           Lat,Long : float64;
         begin
            {$IfDef RecordDEMIXVDatum} writeLineToDebugFile('CheckVerticalDatumShift in, DEM=' + IntToStr(DEM)  + '  ' + DEMGlb[DEM].AreaName); {$EndIf}
            if ValidDEM(DEM) and (DEMGlb[DEM].DEMHeader.VerticalCSTypeGeoKey = VertCSEGM96) then begin
               NewDEM := DEMGlb[DEM].ResaveNewResolution(fcSaveFloatingPoint); //have to resave because input DEMs are all integer resolution
               DEMGlb[NewDEM].AreaName := DEMGlb[DEM].AreaName;  // + '_egm2008';
               DEMGlb[NewDEM].DEMHeader.VerticalCSTypeGeoKey := VertCSEGM2008;
               {$IfDef RecordDEMIXVDatum} writeLineToDebugFile('CheckVerticalDatumShift with shift ' + DEMGlb[DEM].AreaName); {$EndIf}
               z2 := 0;
               for Col := 0 to pred(DEMGlb[NewDEM].DEMHeader.NumCol) do begin
                  for Row := 0 to pred(DEMGlb[NewDEM].DEMHeader.NumRow) do begin
                      if DEMGlb[NewDEM].GetElevMetersOnGrid(Col,Row,z) then begin
                         DEMGlb[NewDEM].DEMGridToLatLongDegree(Col,Row,Lat,Long);
                         if DEMGlb[GeoidGrid].GetElevFromLatLongDegree(Lat,Long,z2) then begin
                            DEMGlb[NewDEM].SetGridElevation(Col,Row,z+z2);
                         end;
                      end;
                  end;
               end;
               CloseSingleDEM(DEM);
               {$IfDef RecordDEMIXLoad} writeLineToDebugFile('Closed DEM; Open DEMs=' + IntToStr(NumDEMdatasetsOpen)); {$EndIf}
               DEMGlb[NewDEM].CheckMaxMinElev;
               DEM := NewDEM;
               {$IfDef RecordDEMIXVDatum} writeLineToDebugFile('CheckVerticalDatumShift out, DEM=' + IntToStr(DEM) + '  ' + DEMGlb[DEM].AreaName); {$EndIf}
            end
            else begin
               {$IfDef RecordDEMIXVDatum} writeLineToDebugFile('CheckVerticalDatumShift out, not EGM96, DEM=' + IntToStr(DEM) + '  ' + DEMGlb[DEM].AreaName); {$EndIf}
            end;
         end;


begin
   {$If Defined(RecordDEMIXLoad)} writeLineToDebugFile('LoadDEMIXCandidateDEMs in; Open DEMs=, ' + IntToStr(NumDEMdatasetsOpen) + '   RefDEM=' + IntToStr(RefDEM)); {$EndIf}
   Result := false;
   if not ValidDEM(RefDEM) then exit;

   {$IfDef RecordDEMIX} AllDEMs := ''; {$EndIf}
   wmdem.SetPanelText(3,'');
   LoadDEMIXnames;

   for I := 1 to MaxDEMIXDEM do begin
      TestDEMs[i] := 0;
      TestSeries[i] := '';
   end;

   AreaName := ShortTestAreaName(AreaName);
   OpenIndexedSeriesTable(IndexSeriesTable);
   IndexSeriesTable.ApplyFilter('USE=' + QuotedStr('Y'));

   Ser := 0;
   for I := 1 to NumDEMIXDEM do begin
      WantSeries := DEMIXDEMTypeName[i];
      //ShortName := DEMIXshort[i];
      fName := DEMIX_test_dems + AreaName + '_' + WantSeries + '.dem';
      if FileExists(fname) then begin
         {$If Defined(RecordDEMIXLoad)} writeLineToDebugFile('Loaded test DEM= ' + fName  ); {$EndIf}
         inc(Ser);
         TestDEMs[Ser] := OpenNewDEM(fName);
         TestSeries[Ser] := WantSeries;
         //TestSeries[Ser] := ShortName;
      end
      else begin
         {$If Defined(RecordDEMIX)} HighlightLineToDebugFile('Missing test DEM= ' + fName  ); {$EndIf}
      end;
   end;

   if (Ser = NumDEMIXDEM) then begin
      Result := true;
      IndexSeriesTable.Destroy;
      exit;
   end;

   GeoidGrid := OpenNewDEM(GeoidDiffFName,false,'geoid difference from EGM96 to EGM2008');  //to move DEMs from EGM96 to EGM2008
   GeoidDiffFName := DEMGlb[GeoidGrid].DEMFileName;

   IndexSeriesTable.First;
   Ser := 0;
   while not IndexSeriesTable.eof do begin
      WantSeries := IndexSeriesTable.GetFieldByNameAsString('SERIES');
      ShortName := IndexSeriesTable.GetFieldByNameAsString('SHORT_NAME');
      SaveName := DEMIX_test_dems + AreaName + '_' + shortname + '.dem';
      wmdem.SetPanelText(3,'Load candidate DEM ' + ShortName);
      if FileExists(SaveName) then begin
      end
      else if AllCandidates or (ShortName = 'COP') or (ShortName = 'ALOS') then begin
         {$If Defined(RecordFullDEMIX) or Defined(RecordDEMIXLoad)} writeLineToDebugFile('Try ' + WantSeries + ' ' + ShortName + '  ' + IntToStr(Ser) + '/' + IntToStr(IndexSeriesTable.FiltRecsInDB)); {$EndIf}
         {$If Defined(RecordFullDEMIX)} writeLineToDebugFile('Ref DEM=' + DEMGlb[RefDEM].AreaName + '  ' + sfBoundBoxToString(DEMGlb[RefDEM].DEMBoundBoxGeo,6)); {$EndIf}
         if LoadMapLibraryBox(WantDEM,WantImage,true,DEMGlb[RefDEM].DEMBoundBoxGeo,WantSeries,false) and ValidDEM(WantDEM) then begin
            {$If Defined(RecordDEMIXLoad)} writeLineToDebugFile('LoadDEMIXCandidateDEMs done LoadMapLib; Open DEMs=, ' + IntToStr(NumDEMdatasetsOpen)); {$EndIf}
            inc(Ser);
            TestDEMs[Ser] := WantDEM;
            TestSeries[Ser] := ShortName;
            {$IfDef RecordDEMIX}
               if not AllOfBoxInAnotherBox(DEMGlb[RefDEM].DEMBoundBoxGeo,DEMGlb[WantDEM].DEMBoundBoxGeo) then begin
                  AllDEMs := AllDEMs + TestSeries[Ser] + ' (partial  ' + sfBoundBoxToString(DEMGlb[RefDEM].DEMBoundBoxGeo) + ')  ';
               end;
            {$EndIf}
            DEMGlb[TestDEMs[Ser]].AreaName := TestSeries[Ser];
            DEMGlb[TestDEMs[Ser]].DEMFileName := NextFileNumber(MDTempDir, DEMGlb[TestDEMs[Ser]].AreaName + '_', '.dem');

            {$IfDef RecordDEMIXLoad} writeLineToDebugFile('Opened:' + WantSeries + '  Open DEMs=' + IntToStr(NumDEMdatasetsOpen)); {$EndIf}
            if (DEMGlb[TestDEMs[Ser]].DEMHeader.MinElev < 0.01) then DEMGlb[TestDEMs[Ser]].MarkInRangeMissing(0,0,NumPts);
            DEMGlb[TestDEMs[Ser]].DEMHeader.VerticalCSTypeGeoKey := IndexSeriesTable.GetFieldByNameAsInteger('VERT_DATUM');
            MoveFromEGM96toEGM2008(TestDEMs[Ser]);
            If OpenMaps or (AreaName <> '') then begin
               CreateDEMSelectionMap(TestDEMs[Ser],true,false,MDDef.DefDEMMap);
               if ValidDEM(RefDEM) then begin
                  DEMGlb[TestDEMs[Ser]].SelectionMap.ClipDEMtoregion(DEMGlb[RefDEM].DEMBoundBoxGeo);
                  {$IfDef RecordDEMIXLoad} writeLineToDebugFile('Clipped:' + WantSeries + '  Open DEMs=' + IntToStr(NumDEMdatasetsOpen)); {$EndIf}
               end;
            end;
            if (AreaName <> '') then begin
               //fName := DEMIX_test_dems + AreaName + '_' + shortname + '.dem';
               DEMGlb[TestDEMs[Ser]].WriteNewFormatDEM(SaveName);
            end;
            Result := true;
         end
         else begin
            {$IfDef RecordDEMIX} AllDEMs := AllDEMs + WantSeries + ' (missing)'; {$EndIf}
         end;
      end;
      IndexSeriesTable.Next;
   end;
   IndexSeriesTable.Destroy;
   CloseSingleDEM(GeoidGrid);
   {$IfDef RecordDEMIX} if (AllDEMs <> '') then HighlightLineToDebugFile(AreaName + ' DEM problem, ' + AllDEMs); {$EndIf}
   {$IfDef RecordDEMIXLoad} writeLineToDebugFile('LoadDEMIXCandidateDEMs out; Open DEMs=, ' + IntToStr(NumDEMdatasetsOpen)); {$EndIf}
end;



function LoadDEMIXReferenceDEMs(var RefDEM : integer; OpenMaps : boolean = true) : boolean;
var
   NumRefDEMs : integer;

         procedure ReferenceFileOpen(var DEM : integer; fName : PathStr);
         begin
            if FileExists(fName) then begin
               DEM := OpenNewDEM(FName,OpenMaps);   //must load map for the DEMIX tile computation
               if ValidDEM(DEM) and (RefDEM = 0) then RefDEM := DEM;
               inc(NumRefDEMs);
               RefDEMs[NumRefDEMs] := DEM;
               {$If Defined(RecordDEMIXRefDEMopen)} writeLineToDebugFile('RefDEM=' + IntToStr(DEM) + '  ' + DEMGlb[DEM].AreaName); {$EndIf}
            end
            else DEM := 0;
         end;

begin
   RefDEM := 0;
   NumRefDEMs := 0;

   ReferenceFileOpen(RefDTMpoint,RefDTMpointFName);
   ReferenceFileOpen(RefDTMarea,RefDTMareaFName);
   ReferenceFileOpen(COPRefDTM,COPRefDTMFName);
   if MDDef.DEMIX_open_ref_DSM then begin
      ReferenceFileOpen(RefDSMpoint,RefDSMpointFName);
      ReferenceFileOpen(RefDSMarea,RefDSMareaFName);
      ReferenceFileOpen(COPRefDSM,COPRefDSMFName);
   end;
   Result := ValidDEM(RefDEM);
   if Result then begin
      {$If Defined(RecordDEMIX)} writeLineToDebugFile('ProcessDEMIXtestarea in, ref DEMs open with RefDEM=' + IntToStr(RefDEM)); {$EndIf}
   end
   else begin
      {$IfDef RecordDEMIX} HighlightLineToDebugFile('Failure, ref DEMs open'); {$EndIf}
   end;
end;



{$include demix_graphs.inc}

{$include demix_create_database.inc}

{$include demix_create_ref_dems.inc}


{$IfDef Old3DEP}
   {$I old_demix_3dep_routines.inc}
{$EndIf}


{$If Defined(AllowEDTM) or Defined(OldDEMIXroutines)}
   {$I experimental_demix_criteria.inc}
{$EndIf}


{$IfDef OpenDEMIXAreaAndCompare}
   {$I open_demix_area.inc}
{$EndIf}




end.





