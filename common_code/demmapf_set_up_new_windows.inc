{^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}
{ Part of MICRODEM GIS Program    }
{ PETMAR Trilobite Breeding Ranch }
{   file verified 7/30/2014       }
{                                 }
{ include file for demmapf        }
{_________________________________}



function TMapForm.MakeTempGrid(OpenMap : boolean = false; GetParameters : boolean = false) : integer;
begin
   {$IfDef RecordMakeGrid} WriteLineToDebugFile('MakeTempGrid in'); {$EndIf}
    if GetParameters then GetGridParameters;
    WGS84DatumConstants.DefineDatumFromUTMZone('WGS84',MDdef.DefaultUTMZone,MDdef.DefaultLatHemi,'LAS RedefineWGS84');
    if (MDDef.LidarGridProjection = UTMBasedDEM) then begin
       Result := CreateGridToMatchMap(cgUTM,OpenMap,FloatingPointDEM,MDDef.DefLidarXGridSize,MDDef.DefLidarYGridSize,MDdef.DefaultUTMZone,MDDef.LasDEMPixelIs);
    end
    else if (MDDef.LidarGridProjection = ArcSecDEM) then begin
       Result := CreateGridToMatchMap(cgLatLong,OpenMap,FloatingPointDEM,MDDef.DefLidarGeoGridSizeX,MDDef.DefLidarGeoGridSizeY,MDdef.DefaultUTMZone,MDDef.LasDEMPixelIs);
    end
    else begin
       Result := CreateGridToMatchMap(cgWKT,OpenMap,FloatingPointDEM,MDDef.DefWKTGridSize,MDDef.DefWKTGridSize,MDdef.DefaultUTMZone,MDDef.LasDEMPixelIs);
    end;
    DEMGlb[Result].DEMheader.ElevUnits := Undefined;
    DEMGlb[Result].AreaName := 'new_grid';
   {$IfDef RecordMakeGrid} WriteLineToDebugFile('MakeTempGrid out'); {$EndIf}
end;


procedure TMapForm.RestoreFullMap;
begin
   {$If Defined(RecordMapDraw) or Defined(RecordMapResize)} WriteLineToDebugFile('TMapForm.RestoreFullMap in ' + Caption + '  ' + MapDraw.MapSizeString); {$EndIf}
   if LockMaps then begin
      MessageToContinue('Maps locked for digitizing');
   end
   else begin
      MapDraw.ZeroTickInt;
      SetClientHeight;
      DEMDoingWhatBefore := DEMNowDoing;
      {$If Defined(RecordMapDraw) or Defined(RecordMapResize)} WriteLineToDebugFile('TMapForm.RestoreFullMap call MapDraw.SetFullMapCoverage'); {$EndIf}
      MapDraw.SetFullMapCoverage;
      {$If Defined(RecordMapDraw) or Defined(RecordMapResize)} WriteLineToDebugFile('TMapForm.RestoreFullMap call DoCompleteMapRedraw'); {$EndIf}
      DoCompleteMapRedraw;
      FullMapSpeedButton.Enabled := false;
      ChangeDEMNowDoing(DEMDoingWhatBefore);
      {$If Defined(RecordMapDraw) or Defined(RecordMapResize)} WriteLineToDebugFile('TMapForm.RestoreFullMap out ' + '  ' + MapDraw.MapSizeString); {$EndIf}
   end;
end;



function LoadBlankVectorMapAndOverlay(ItsTiger,ItsGazetteer : boolean; fName : Pathstr = '') : integer;
var
   db        : integer;
   Lat1,Long1,Lat2,Long2,{Sum,}extra : float64;
   fNames : tStringList;
   aName : ShortString;
begin
   {$IfDef RecordOpenVectorMap} writeLineToDebugFile('LoadBlankVectorMapAndOverlay in'); {$EndIf}
   fNames := Nil;
   Result := SetUpVectorMap(false,false);
   VectorMap[Result].FormStyle := fsNormal;
   VectorMap[Result].Visible := false;
   {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('LoadBlankVectorMapAndOverlay set up'); {$EndIf}
   with VectorMap[Result],MapDraw do begin
      MapXSize := MDdef.DefaultMapXSize;
      MapYSize := MDdef.DefaultMapYSize;
      if ItsTiger then begin
         {$IfDef ExTIGER}
         {$Else}
         {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('LoadBlankVectorMapAndOverlay call DEMTiger.GetTIGERCounty'); {$EndIf}
         if (Fname <> '') then begin
            fNames := tStringList.Create;
            fNames.Add(fName);
         end
         else fNames := Nil;
         if (not DEMTiger.GetTIGERCounty(fNames,Lat1,Long1,Lat2,Long2,aName)) then exit;
         {$EndIf}
         VectorMap[Result].MapDraw.BaseTitle := aName + ' TIGER county map';
      end;

      if ItsTiger then begin
         fName := fNames[0];
     end;
     {$IfDef RecordOpenVectorMap}   if (fName = '') then WriteLineToDebugFile('get db name (time to next step includes user delay)'); {$EndIf}
     db := VectorMap[Result].OpenDBonMap('',fName);
     {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('VectorMap[i].OpenDBonMap over'); {$EndIf}
     if (db = 0) then begin
        VectorMap[Result].Close;
        Result := 0;
        exit;
     end
     else begin
         {$IfDef RecordOpenVectorMap} writeLineToDebugFile('GIS map needed'); {$EndIf}
         if (UpperCase(Copy(GISdb[db].dbName,1,2)) = 'TL') then ItsTiger := true;
         if not (GISdb[db].ItsAShapeFile) then begin
            GISdb[db].EmpSource.Enabled := false;
            if not (GISdb[db].MyData.FindFieldRange(GISdb[db].LatFieldName,Lat1,Lat2)
               and GISdb[db].MyData.FindFieldRange(GISdb[db].LongFieldName,Long1,Long2)) then exit;
            GISdb[db].EmpSource.Enabled := true;
         end
         else begin
            Long1 := GISdb[db].aShapeFile.MainFileHeader.BoundBox.XMin;
            Lat1 := GISdb[db].aShapeFile.MainFileHeader.BoundBox.YMin;
            Long2 := GISdb[db].aShapeFile.MainFileHeader.BoundBox.XMax;
            Lat2 := GISdb[db].aShapeFile.MainFileHeader.BoundBox.YMax;
            {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('Shape file NW corner: ' + LatLongDegreeToString(Lat2,Long1) + '  SE corner: ' + LatLongDegreeToString(Lat1,Long2)); {$EndIf}
         end;
         VectorMap[Result].MapDraw.BaseTitle := 'DB map: ' + GISdb[db].dbName;
         {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('GIS map OK'); {$EndIf}
         if ItsGazetteer then GISdb[db].SetGazTableOptions;
     end;
      VectorMap[Result].FormStyle := fsMDIchild;

      VectorMap[Result].FullMapSpeedButton.Visible := false;
      VectorMap[Result].MapDraw.PrimMapProj.SetDatumConstants;
      PrimMapProj.DefineDatumFromUTMZone('WGS84',GetUTMZone(Long2),HemiFromLat(Lat1),'LoadBlankVectorMapAndOverlay');

      if (abs(long2-long1) < 180) then begin
         extra := MDDef.LatLongCushion * abs(Lat1-Lat2);
         //MapDraw.OriginalSizemap := false;
         MapDraw.MaximizeLatLongMapCoverage( (Lat1 - extra),(Long1 - extra),(Lat2 + extra),(Long2 + extra) );
         FormResize(nil);
         DoCompleteMapRedraw;
      end;

      MapDraw.ZeroTickInt;

      {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('Drawing is next'); {$EndIf}
      if ItsTIGER and MDDef.TigrDef.ShowNeighborsOnTIGERCounty then AddOrSubtractOverlay(VectorMap[Result],ovoTiger,True);
   end;
   StopSplashing;
   {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('LoadBlankVectorMapAndOverlay out=' + IntToStr(Result)); {$EndIf}
end;


function SetUpVectorMap(DrawIt,WorldOutline : boolean; WantProjection : tProjectType = undefinedProj; ProjName : PathStr = '') : integer;
var
   i : integer;
begin
   {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('SetUpVectorMap in'); {$EndIf}
   i := 0;
   repeat
       inc(i);
   until (I > MaxVectorMap) or (VectorMap[i] = Nil);
   if (i > MaxVectorMap) then begin
      MessageToContinue('Too many maps open');
      Result := 0;
   end
   else begin
      {$IfDef RecordOpenVectorMap} WriteLineToDebugFile('new VectorMap=' + IntToStr(i)); {$EndIf}
      Result := i;
      VectorMap[i] := SetUpANewVectorMap(i,DrawIt,WorldOutline,WantProjection,ProjName);
   end;
end;


function SetUpANewVectorMap(i : integer; DrawIt,WorldOutline : boolean; WantProjection : tProjectType = undefinedProj; ProjName : PathStr = '') : tMapForm;

         procedure SetProjection(WantProjection : tProjectType);
         begin
              Result.MapDraw.PrimMapProj.PName := WantProjection;
              Result.MapDraw.PrimMapProj.ProjectionfName := '';
              SetUpDefaultNewProjection(Result.MapDraw.PrimMapProj);
              Result.MapDraw.PrimMapProj.GetProjectParameters;
         end;

begin
   {$IfDef RecordOpenVectorMap} writeLineToDebugFile('SetUpANewVectorMap in, ProjName=' + ProjName); {$EndIf}
   Result := TMapForm.Create(Application);
   with Result do begin
       MapDraw.MapOwner := moVectorMap;
       if WorldOutline then AddOverlay(Result,ovoWorldOutlines);
       MapDraw.VectorIndex := i;
       MapDraw.MakeMapGrayscale := MDDef.DefGrayVectMap;
       MapDraw.SubdueBase := MDDef.DefSubdueVectMap;
       MapDraw.PrimMapProj := tMapProjection.Create('vect map prim proj');
       //MapDraw.SecondaryMapProjection := tMapProjection.Create('vector map secondary projection');

       if (WantProjection <> undefinedProj) then begin
           SetProjection(WantProjection);
       end
       else if (ProjName = '') then begin
          if (MDdef.DefaultVectorMapProjection = dvmDefined) then begin
             MapDraw.PrimMapProj.ProjectionfName := VectorMapName;
          end
          else begin
             case MDdef.DefaultVectorMapProjection of
                dvmMercator{,dvmConusMerc} :  SetProjection(MercatorEllipsoid);
                dvmConicalArea      :  SetProjection(AlbersEqAreaConicalEllipsoid);
                dvmConicalConformal :  SetProjection(LambertConformalConicEllipse);
             end;
          end;
       end;
       {$IfDef RecordOpenVectorMap} (if ProjName <> '') then WriteLineToDebugFile('After setting, ProjName=' + ProjName); {$EndIf}

       Result.MapDraw.PrimMapProj.PName := MapDraw.PrimMapProj.PName;
       //Result.MapDraw.SecondaryMapProjection.PName := MapDraw.PrimMapProj.PName;
       MapDraw.BaseTitle := MapDraw.PrimMapProj.GetProjectionName;
       MapDraw.AdjustProjectionForUTMZone('New vector map',MDDef.PreferPrimaryDatum,MDDef.DefaultUTMZone,MDDef.DefaultLatHemi);
       {$If Defined(RecordOpenVectorMap)} WriteLineToDebugFile('New vector map: ' + MapDraw.PrimMapProj.GetProjectionName); {$EndIf}

       MapDraw.SetFullMapCoverage;
       MapDraw.ResetMarginalia;
       if DrawIt then DoCompleteMapRedraw;
    end;
end;



procedure CreateDEMSelectionMap(DEM : integer; DrawIt : boolean = true; usePC : boolean = true; inMapType : tMapType = mtElevRainbow);
var
   mt : tMapType;


      function GetWantedMapType : tMapType;
      var
         fName2,MPath : PathStr;
      begin
         //if MDdef.DefDEMMap in [2] then MDdef.DefDEMMap := mtIHSReflect;

         if (not DEMGlb[DEM].ElevationDEM) then Result := mtElevRainbow
         else Result := MDdef.DefDEMMap;

         if FileExists(ChangeFileExt(DEMGlb[DEM].DEMFileName,'.vat.dbf')) or FileExists(DEMGlb[DEM].DEMFileName + '.vat.dbf') then begin
            DEMGlb[DEM].CreateVATforDEM;
            Result := mtDEMVATTable;
         end
         else if IsThisSentinel2(DEMGlb[DEM].DEMFileName) or IsLandsat(DEMGlb[DEM].DEMFileName, MPath) or (DEMGlb[DEM].DEMheader.ElevUnits in [euImagery]) then Result := mtElevGray
         else if (DEMGlb[DEM].DEMheader.ElevUnits in [euRGB]) then Result := mtRGB
         else if (DEMGlb[DEM].DEMheader.ElevUnits in [AspectDeg]) then Result := mtDEMaspect
         else if (DEMGlb[DEM].DEMheader.ElevUnits in [euIntCode]) or (abs(DEMGlb[DEM].DEMheader.MaxElev - DEMGlb[DEM].DEMheader.MinElev) < 0.00001) then Result := mtElevContrast
         {$IfDef ExPointCloud}
         {$Else}
         else if DEMGlb[DEM].DEMHeader.ElevUnits in [euLASclass13] then begin
            Result := mtLASclass;
            LAS_Lidar.InitializeLASColors;
         end
         {$EndIf}
         else if DEMGlb[DEM].LandCoverGrid then begin
            Result := mtElevRainbow;
            {$IfDef RecordOpenMap} writeLineToDebugFile('=LandCoverGrid'); {$EndIf}
         end
         else begin
            fName2 := UpperCase(DEMGlb[DEM].DEMFileName);
            if (StrUtils.AnsiContainsText(fName2,'NIGHT') and StrUtils.AnsiContainsText(fName2,'LIGHT')) or StrUtils.AnsiContainsText(fName2,'BAND') then begin
               Result := mtElevGray;
               DEMGlb[DEM].DEMheader.ElevUnits := Undefined;
               DEMGlb[DEM].ElevationDEM := false;
            end;
         end;
      end;


begin
   {$IfDef NoMapOptions}
   {$Else}
      {$If Defined(RecordOpenMap) or Defined(RecordCreateSelectionMap)} writeLineToDebugFile('CreateDEMSelectionMap in, DEM=' + IntToStr(DEM)); {$EndIf}
      DEMGlb[DEM].SelectionMap := TMapForm.Create(Application);
      DEMGlb[DEM].SelectionMap.MapDraw.PrimMapProj := DEMGlb[DEM].DEMMapProjection;
      {$If Defined(track_f)} DEMGlb[DEM].DEMMapProjection.ShortProjInfo('CreateDEMSelectionMap, DEM'); {$EndIf}
      {$If Defined(track_f)} DEMGlb[DEM].SelectionMap.MapDraw.PrimMapProj.ShortProjInfo('CreateDEMSelectionMap, map'); {$EndIf}
      if (inMapType = mtDEMBlank) then mt := GetWantedMapType
      else mt := inMapType;
      {$If Defined(RecordOpenMap) or Defined(RecordCreateSelectionMap)} writeLineToDebugFile('CreateDEMSelectionMap call SetUpNewDEMMapWindow'); {$EndIf}
      DEMGlb[DEM].SelectionMap.SetUpNewDEMMapWindow(DEM,mt,DEMGlb[DEM].AreaName,true,DrawIt,UsePC);
      {$If Defined(RecordOpenMap) or Defined(RecordCreateSelectionMap)} writeLineToDebugFile('CreateDEMSelectionMap out,' + DEMGlb[DEM].SelectionMap.MapDraw.MapSizeString); {$EndIf}
   {$EndIf}
end;

function CreateANewDEMMapWindow(CurDEM : integer; DrawIt : boolean; mt : tMapType; MapCaption : ShortString) : tMapForm;
begin
   Result := TMapForm.Create(Application);
   Result.MapDraw.FirstMapDrawing := false;
   Result.SetUpNewDEMMapWindow(CurDEM,mt,MapCaption,false,DrawIt,false);
end;


procedure TMapForm.SetUpNewDEMMapWindow(CurDEM : integer; mt : tMapType; MapCaption : ShortString; Selection,DrawIt,UsePC : boolean);
begin
   {$If Defined(RecordSetup) or Defined(RecordCreateSelectionMap)} WriteLineToDebugFile('TMapForm.SetUpNewDEMMapWindow, DEM=' + IntToStr(CurDEM) + '  maptype=' + IntToStr(ord(mt)) + '  ' + MapDraw.MapSizeString); {$EndIf}
   try
      if Selection then begin
         MapDraw.MapOwner := moDEMSelectionMap;
         Closable := false;
      end;
      if (not DrawIt) then mt := mtDEMblank;
      MapDraw.Long0_360 := DEMGlb[CurDEM].DEMBoundBoxGeo.xmax > 181;
      MapDraw.BaseTitle := MapCaption;
      MapDraw.UsePercentiles := UsePC;
      MapDraw.DefineNewDEMMap(CurDEM,mt);
      {$If Defined(RecordSetup) or Defined(RecordCreateSelectionMap)} WriteLineToDebugFile('TMapForm.SetUpNewDEMMapWindow DefineNewDEMMap over'); {$EndIf}
      if MDDef.NEAutoDEM then AddOverlay(Self,ovoWorldOutlines);
      SetMapOverlays;
      MapDraw.ResetMarginalia;
      if DrawIt then begin
         try
            {$If Defined(RecordSetup) or Defined(RecordCreateSelectionMap)} WriteLineToDebugFile('TMapForm.SetUpNewDEMMapWindow Drawing'); {$EndIf}
            DoCompleteMapRedraw;
         except
            on Exception do begin end;
         end;
         Visible := true;
         SetFocus;
      end;
   finally
      ShowDefaultCursor;
   end;
   {$If Defined(RecordSetup) or Defined(RecordCreateSelectionMap)} WriteLineToDebugFile('TMapForm.SetUpNewDEMMapWindow exit ' + MapCaption + '  ' + MapDraw.MapSizeString); {$EndIf}
end;


{$IfDef ExSat}
{$Else}
      procedure CreateNewSatSubsetWindow(inSatView : tSatView; var ResultMap : tMapForm; CurSat : integer; mt : tMapType; MapCaption : ShortString; Roamable,Selection,ReallyDraw : boolean; UseDEM : integer = 0);
      var
         xg,yg : float64;
         Inbounds : boolean;


         procedure SetUpTheNewMap(var ThisMap : tMapForm);
         var
            Lat,Long : float64;
         begin
            {$IfDef RecordNewSatMap} WriteLineToDebugFile('SetUpTheNewMap (Sat window) in'); {$EndIf}
            try
               ThisMap.MapDraw.BaseTitle := MapCaption;
               ThisMap.MapDraw.aDRGmap := GlobalDRGMap;
               ThisMap.MapDraw.DefineSatMap(CurSat,mt);
               if MDDef.NEAutoSat then AddOverlay(ResultMap,ovoWorldOutlines);
               ThisMap.MapDraw.PrimMapProj := SatImage[CurSat].ImageMapProjection;
               if (NumDEMDataSetsOpen = 0) then begin
                  {$IfDef RecordAssociateDEMwithImage} WriteLineToDebugFile('Cannot Associate DEM, NumDEMDataSetsOpen = 0'); {$EndIf}
               end
               else begin
                  if (UseDEM = 0) then begin
                     {$IfDef RecordAssociateDEMwithImage} WriteLineToDebugFile('UseDEM = 0' +  '  Image center is ' + LatLongDegreeToString(Lat,Long,DecDegrees)); {$EndIf}
                     repeat
                        inc(ThisMap.MapDraw.DEMonMap);
                        InBounds := false;
                        if (DEMGlb[ThisMap.MapDraw.DEMonMap] <> Nil) and (DEMGlb[ThisMap.MapDraw.DEMonMap].ElevationDEM) then begin
                           DEMGlb[ThisMap.MapDraw.DEMonMap].LatLongDegreeToDEMGrid(Lat,Long,xg,yg);
                           InBounds := DEMGlb[ThisMap.MapDraw.DEMonMap].GridInDataSet(xg,yg);
                        end;
                     until Inbounds or (ThisMap.MapDraw.DEMonMap = MaxDEMDataSets);
                     if (not Inbounds) then begin
                        {$IfDef RecordAssociateDEMwithImage} WriteLineToDebugFile('No DEM match, asking'); {$EndIf}
                        ThisMap.MapDraw.DEMonMap := 1;
                     end;
                  end
                  else ThisMap.MapDraw.DEMonMap := UseDEM;
                  {$IfDef RecordAssociateDEMwithImage} if ValidDEMonMap then WriteLineToDebugFile('DEM with image ' + DEMGlb[DEMonMap].KeyDEMParams); {$EndIf}
               end;

               if ReallyDraw then begin
                  {$IfDef RecordNewSatMap} WriteLineToDebugFile('Call SetMapOverlays'); {$EndIf}
                  ThisMap.SetMapOverlays;
                  {$IfDef RecordNewSatMap} WriteLineToDebugFile('Done SetMapOverlays'); {$EndIf}
                  ThisMap.RestoreFullMap;
                  {$IfDef RecordNewSatMap} WriteLineToDebugFile('Done RestoreFullMap'); {$EndIf}
               end;
               ThisMap.SetFocus;
            finally
                ShowDefaultCursor;
            end;
            {$IfDef RecordNewSatMap} WriteLineToDebugFile('SetUpTheNewMap out'); {$EndIf}
         end;

      begin
         {$IfDef RecordNewSatMap} WriteLineToDebugFile('In CreateNewSatSubsetWindow image: ' + IntToStr(NewSatImage)); {$EndIf}
         if (ResultMap = Nil) then begin
            ResultMap := TMapForm.Create(Application);
            {$IfDef RecordNewSatMap} WriteLineToDebugFile('New form created'); {$EndIf}
         end;
         ResultMap.MapDraw.SatView := inSatView;
         ResultMap.Mapdraw.SatOnMap := CurSat;
         if (ResultMap.MapDraw.SatView.BandInWindow > SatImage[Cursat].NumBands) then begin
            ResultMap.MapDraw.SatView.BandInWindow := 1;
         end;

         if Selection then begin
            ResultMap.Closable := not Selection;
            ResultMap.MapDraw.MapOwner := moImageSelectionMap;
         end;

         SetUpTheNewMap(ResultMap);
         ResultMap.CheckProperTix;
         {$IfDef RecordNewSatMap} WriteLineToDebugFile('Out CreateNewSatSubsetWindow image: ' + IntToStr(NewSatImage)); {$EndIf}
      end;


      procedure CreateNewSatWindow(inSatView : tSatView; var ResultMap : tMapForm; CurSat : integer; mt : tMapType; MapCaption : ShortString; Selection : boolean; UseDEM : integer = 0);
      begin
         {$IfDef RecordNewSatMap} WriteLineToDebugFile('CreateNewSatWindow image: ' + IntToStr(NewSatImage)); {$EndIf}
         CreateNewSatSubsetWindow(inSatView, ResultMap,CurSat,mt,MapCaption,false,Selection,true,UseDEM);
         {$IfDef RecordNewSatMap} WriteLineToDebugFile('out CreateNewSatWindow'); {$EndIf}
      end;
{$EndIf}



