﻿program microdem;

{^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^}
{ Part of MICRODEM GIS Program       }
{ PETMAR Trilobite Breeding Ranch    }
{ Released under the MIT Licences    }
{ Copyright (c) 2024 Peter L. Guth   }
{____________________________________}

{$I nevadia_defines.inc}











uses
  Forms,
  SysUtils,
  Windows,
  MidasLib,
  nevadia_main in '..\microdem_only_code\nevadia_main.pas' {wmdem},
  sc_colpated in '..\stratcol\sc_colpated.pas' {StratcolPatternEditor},
  sc_ColMain in '..\stratcol\sc_ColMain.pas' {ColMainF},
  sc_COLLABEL in '..\stratcol\sc_COLLABEL.PAS' {Collabf},
  sc_COLHEAD in '..\stratcol\sc_COLHEAD.PAS' {ColumnHeaderEntry},
  sc_fossil in '..\stratcol\sc_fossil.pas' {FossilRangeOptions},
  sc_COLENTER in '..\stratcol\sc_COLENTER.PAS' {FullUnitEntryDlg},
  sc_ColLith in '..\stratcol\sc_ColLith.pas' {patternf},
  sc_colopts in '..\stratcol\sc_colopts.pas' {StratOptsForm},
  OKCANCL2 in '..\common_code\OKCANCL2.PAS' {OKRightDlg},
  slicer_3d in '..\common_code\slicer_3d.pas' {SlicerForm},
  DEMLOSW in '..\common_code\DEMLOSW.pas' {DEMLOSF},
  pit_and_spire in '..\common_code\pit_and_spire.pas' {PitSpireForm},
  DEMLOSOp in '..\common_code\DEMLOSOp.pas' {LOSOption},
  DEM_indexes in '..\common_code\DEM_indexes.pas',
  dem_legend in '..\common_code\dem_legend.pas' {SetUpLegendForm},
  thread_timers in '..\common_code\thread_timers.pas' {ThreadTimerForm},
  BaseGraf in '..\common_code\BaseGraf.pas' {ThisBaseGraph},
  demoptions in '..\common_code\demoptions.pas' {OptionsForm},
  veg_density in '..\common_code\veg_density.pas',
  fresnel_block_form in '..\common_code\fresnel_block_form.pas' {Fres_blockf},
  DEMweapn in '..\common_code\DEMweapn.pas' {PickWeapon},
  lvis in '..\common_code\lvis.pas',
  sup_class in '..\common_code\sup_class.pas' {supclasform},
  Get_PLSS in '..\common_code\Get_PLSS.pas' {getplssf},
  DEMEditW in '..\common_code\DEMEditW.pas' {DEMeditForm},
  DEM_PLSS in '..\common_code\DEM_PLSS.pas',
  Plate_Rotate in '..\common_code\Plate_Rotate.pas' {PickRotationForm},
  dem_milicon in '..\common_code\dem_milicon.pas' {MilIconsForm},
  csv_export in '..\common_code\csv_export.pas' {CVSExportForm},
  compress_form in '..\common_code\compress_form.pas' {petcompressform},
  demcnvrt in '..\common_code\demcnvrt.pas' {CoordConverter},
  map_algebra in '..\common_code\map_algebra.pas' {MapAlgebraForm},
  getlatln in '..\common_code\getlatln.pas' {GetLatLongDlg},
  Demperop in '..\common_code\Demperop.pas' {PerspOptions},
  hyp_display in '..\common_code\hyp_display.pas' {HyperspectralForm},
  demprintpreview in '..\common_code\demprintpreview.pas' {PrintPreviewForm},
  kml_creator in '..\common_code\kml_creator.pas',
  demtrendopt in '..\common_code\demtrendopt.pas' {TrendPick},
  PETFouri in '..\common_code\PETFouri.pas' {FFTGraph},
  UK_OS_Converter in '..\common_code\UK_OS_Converter.pas' {UKOSConvertForm},
  NETOPTS in '..\common_code\NETOPTS.PAS' {NetOptFm},
  insert_point in '..\common_code\insert_point.pas' {InsertPointForm},
  elev_color_range in '..\common_code\elev_color_range.pas' {ElevationRangeForm},
  demterrc in '..\common_code\demterrc.pas' {GetTerrC},
  kml_opts in '..\common_code\kml_opts.pas' {kml_opts_fm},
  GIS_Scaled_symbols in '..\common_code\GIS_Scaled_symbols.pas' {gis_scaled_form},
  add_time_fields in '..\common_code\add_time_fields.pas' {TimeFieldsForm},
  DEMXYZIm in '..\common_code\DEMXYZIm.pas' {ImportParamsDialog},
  Contgraf in '..\common_code\Contgraf.pas' {ThisContourGraph},
  pick_county in '..\common_code\pick_county.pas' {pickcounty},
  DataBaseAddRec in '..\common_code\DataBaseAddRec.pas' {DbaddRecForm},
  sun_position in '..\common_code\sun_position.pas',
  DEMTiger in '..\common_code\DEMTiger.pas',
  DEMShowDbRecord in '..\common_code\DEMShowDbRecord.pas' {showrecordform},
  dem_cart_proj in '..\common_code\dem_cart_proj.pas' {ProjectionDemForm},
  zipatone in '..\common_code\zipatone.pas',
  demelevops in '..\common_code\demelevops.pas' {ElevOptionsForm},
  map_overlays in '..\common_code\map_overlays.pas' {MapOverlayForm},
  block_opts in '..\common_code\block_opts.pas' {BlockOpsForm},
  map_masking in '..\common_code\map_masking.pas' {MapMaskForm},
  plss_converter in '..\common_code\plss_converter.pas' {PLSSConvertForm},
  GeologicTimeScale in '..\common_code\GeologicTimeScale.pas',
  gps_strings in '..\common_code\gps_strings.pas',
  drainage_opts in '..\common_code\drainage_opts.pas' {drain_opt_form},
  get_angle in '..\common_code\get_angle.pas' {get_angle_form},
  PETDATE in '..\common_code\PETDATE.PAS' {GetDateForm},
  message_continue in '..\common_code\message_continue.pas' {mess_cont_form},
  legend_placement in '..\common_code\legend_placement.pas' {leg_opts_form},
  map_options in '..\common_code\map_options.pas' {TMapOptsForm},
  cart_movie_options in '..\common_code\cart_movie_options.pas' {CartMovieOptsForm},
  clusterOptions in '..\common_code\clusterOptions.pas' {ClusterOptsForm},
  computations in '..\common_code\computations.pas' {CompForm},
  dem_hist_opts in '..\common_code\dem_hist_opts.pas' {HistOptForm},
  dem_map_scale in '..\common_code\dem_map_scale.pas' {MapScaledForm},
  koppen_opts in '..\common_code\koppen_opts.pas' {Koppen_opt_f},
  demmarginalia in '..\common_code\demmarginalia.pas' {DemMarginaliaForm},
  mask_opts_form in '..\common_code\mask_opts_form.pas' {MaskOptsForm},
  optima_reg in '..\common_code\optima_reg.pas' {RegOptsForm},
  pick_limits in '..\common_code\pick_limits.pas' {picklimitsForm},
  mask_multiple in '..\common_code\mask_multiple.pas' {Mask_mult_form},
  demconop in '..\common_code\demconop.pas' {ContourOptions},
  dem_plss_op in '..\common_code\dem_plss_op.pas' {PLSSform},
  DEMGrPik in '..\common_code\DEMGrPik.pas' {PickGrid},
  NetMainW in '..\common_code\NetMainW.pas' {NetForm},
  Beach_Ball_Options in '..\common_code\Beach_Ball_Options.pas' {BeachBallForm},
  demslopeopts in '..\common_code\demslopeopts.pas' {SlopeOptForm},
  demrefop in '..\common_code\demrefop.pas' {RefOptFM},
  rgb_colors_three_params in '..\common_code\rgb_colors_three_params.pas' {RGB_form},
  MEM_Power_spect in '..\common_code\MEM_Power_spect.pas' {MemForm},
  new_field in '..\common_code\new_field.pas' {NewFieldForm},
  stereo_viewer in '..\common_code\stereo_viewer.pas' {StereoViewerForm},
  speed_dist_form in '..\common_code\speed_dist_form.pas' {SpeedDistanceForm},
  db_display_options in '..\common_code\db_display_options.pas' {db_display_opts},
  db_field_concatenate in '..\common_code\db_field_concatenate.pas' {db_concatenate},
  dem_fan_algorithm in '..\common_code\dem_fan_algorithm.pas' {FanAlgParams},
  Least_cost_path in '..\common_code\Least_cost_path.pas',
  demstringgrid in '..\common_code\demstringgrid.pas' {GridForm},
  basin_flooding in '..\common_code\basin_flooding.pas' {FloodingForm},
  db_join in '..\common_code\db_join.pas' {dbjoinform2},
  altcommr in '..\common_code\altcommr.pas',
  toggle_db_use in '..\common_code\toggle_db_use.pas' {ToggleDBfieldsForm},
  lvis_form in '..\common_code\lvis_form.pas' {lvis_form1},
  map_route in '..\common_code\map_route.pas' {MapRtForm},
  dem_tin in '..\common_code\dem_tin.pas',
  sup_class_aux_grids in '..\common_code\sup_class_aux_grids.pas' {SupClassAuxGrids},
  drg_anaglyph in '..\common_code\drg_anaglyph.pas' {DRGAnaglyphForm},
  us_properties in '..\common_code\us_properties.pas',
  KoppenGr in '..\common_code\KoppenGr.pas' {KoppenGraph},
  hyperspectral_image in '..\common_code\hyperspectral_image.pas',
  demrange in '..\common_code\demrange.pas' {RangeCircleForm},
  ant_hts_ops in '..\common_code\ant_hts_ops.pas' {ReqAntOptsForm},
  dempanorama in '..\common_code\dempanorama.pas' {PanoramaOps},
  get_sunrise in '..\common_code\get_sunrise.pas' {sunrisepicker},
  DEMTigerOps in '..\common_code\DEMTigerOps.pas' {TigerOverlayOptions},
  ternoptions in '..\common_code\ternoptions.pas' {TernOptForm},
  DEMVAROP in '..\common_code\DEMVAROP.PAS' {VariogramOptions},
  pc_options in '..\common_code\pc_options.pas' {pc_opts_form},
  three_point_problem in '..\common_code\three_point_problem.pas' {ThreePointer},
  kml_overlay in '..\common_code\kml_overlay.pas' {KML_over_opts},
  mag_prof in '..\common_code\mag_prof.pas' {PickMagProfVars},
  check_8_dirs in '..\common_code\check_8_dirs.pas' {GetDir8},
  petprogr in '..\common_code\petprogr.pas' {PetProgF},
  PETMARAbout in '..\common_code\PETMARAbout.pas' {PetmarAboutBox},
  petform in '..\common_code\petform.pas' {PETMARCommonForm},
  peted32 in '..\common_code\peted32.pas' {PetEditf},
  netconbr in '..\common_code\netconbr.pas' {InputArrays},
  graphset in '..\common_code\graphset.pas' {GraphSettingsForm},
  demfanparams in '..\common_code\demfanparams.pas' {PickFanParams},
  dem_gaz_opts in '..\common_code\dem_gaz_opts.pas' {GazOptsForm},
  demdbdisplay in '..\common_code\demdbdisplay.pas' {dblimit},
  image_erode_dilate in '..\common_code\image_erode_dilate.pas' {DilateErodeForm},
  petgetline in '..\common_code\petgetline.pas' {lineparamsform},
  pickfillpattern in '..\common_code\pickfillpattern.pas' {PickFillForm},
  dempickdatum in '..\common_code\dempickdatum.pas' {PickDatumParams},
  text_report_options in '..\common_code\text_report_options.pas' {ReportOptionsForm},
  fan_sens_opts in '..\common_code\fan_sens_opts.pas' {fan_sens_form},
  get_db_coloring in '..\common_code\get_db_coloring.pas' {DBColorForm},
  FitFourier in '..\common_code\FitFourier.pas' {FitFourierForm},
  crosscor in '..\common_code\crosscor.pas' {CrossCorrelationForm},
  get_thumbnails in '..\common_code\get_thumbnails.pas' {ThumbnailForm},
  petgraphcolors in '..\common_code\petgraphcolors.pas' {graphcolorsform},
  horizon_opts in '..\common_code\horizon_opts.pas' {HorizonOptions},
  demdbfieldpicker in '..\common_code\demdbfieldpicker.pas' {FieldPicker},
  tissot in '..\common_code\tissot.pas' {TissotOpts},
  demcurvature in '..\common_code\demcurvature.pas' {CurvatureForm},
  demfabricregion in '..\common_code\demfabricregion.pas' {FabricOptions},
  demslopecompare in '..\common_code\demslopecompare.pas' {SlopeCompareOptions},
  demslped in '..\common_code\demslped.pas' {SlopeCategoryEditor},
  dem_digit_opts in '..\common_code\dem_digit_opts.pas' {DEMDigitOptions},
  dem_grid_diffs in '..\common_code\dem_grid_diffs.pas' {GridDiffForm},
  grid_postings_form in '..\common_code\grid_postings_form.pas' {grid_posting_options},
  dem_save_dted in '..\common_code\dem_save_dted.pas' {Dted_save_form},
  dem_optimal_lag in '..\common_code\dem_optimal_lag.pas' {LagOptionsForm},
  ne_outlines in '..\common_code\ne_outlines.pas' {NEOutlineForm},
  slope_graph_opts in '..\common_code\slope_graph_opts.pas' {slopegraphopts},
  moment_opts in '..\common_code\moment_opts.pas' {MomentOptsForm},
  MVClusterClientDataSet in '..\common_code\MVClusterClientDataSet.pas',
  DEMXYZdisplay in '..\common_code\DEMXYZdisplay.pas' {XYZDisplayForm},
  petfont in '..\common_code\petfont.pas' {FontDlg},
  demsatcontrast in '..\common_code\demsatcontrast.pas' {EROSContrastForm},
  petsymbol in '..\common_code\petsymbol.pas' {PickSymbolForm},
  OCEANCAL in '..\common_code\OCEANCAL.PAS',
  demxyzexport in '..\common_code\demxyzexport.pas' {XYZformatform},
  DEMDips in '..\common_code\DEMDips.pas' {StructureOptions},
  edit_dip in '..\common_code\edit_dip.pas' {GetDipStrike},
  petbmpsize in '..\common_code\petbmpsize.pas' {NewBMPForm},
  PETCorrl in '..\common_code\PETCorrl.pas' {CorrelationForm},
  petlistf in '..\common_code\petlistf.pas' {PetList},
  trackstarmain in '..\common_code\trackstarmain.pas' {SatTractForm},
  ParseExpr in '..\common_code\ParseExpr.pas',
  ParseClass in '..\common_code\ParseClass.pas',
  oObjects in '..\common_code\oObjects.pas',
  demflysense in '..\common_code\demflysense.pas' {FlightControlSensitivity},
  demflycontrols in '..\common_code\demflycontrols.pas' {FlightControlForm},
  OKCANCL1 in '..\common_code\OKCANCL1.PAS' {OKBottomDlg},
  contouroptsform in '..\common_code\contouroptsform.pas' {SimpleContourOptions},
  FourOpF in '..\common_code\FourOpF.pas' {FourierOptionsForm},
  dem_fan_compare in '..\common_code\dem_fan_compare.pas' {FanCompareForm},
  dem_sat_header in '..\common_code\dem_sat_header.pas' {SatHeaderForm},
  net_quiz in '..\common_code\net_quiz.pas' {NetQuizForm},
  net_entry in '..\common_code\net_entry.pas' {NetEntryForm},
  multigrid in '..\common_code\multigrid.pas',
  grid_over_map in '..\common_code\grid_over_map.pas' {GridOverlayonMap},
  raster_2_vector in '..\common_code\raster_2_vector.pas' {rast_2_vect_f},
  mask_opts2 in '..\common_code\mask_opts2.pas' {GridMaskOptForm},
  feature_migration in '..\common_code\feature_migration.pas' {FeatureMigrationForm},
  param_graphs in '..\gis_db\param_graphs.pas' {ParamGraphForm},
  petimage_form in '..\common_code\petimage_form.pas' {ImageDisplayForm},
  demhandw in '..\common_code\demhandw.pas' {DemHandForm},
  usoutlines in '..\common_code\usoutlines.pas' {USOutlineForm},
  main_gray_game in '..\common_code\main_gray_game.pas' {GrayGameForm},
  make_grid in '..\common_code\make_grid.pas',
  survey_lines in '..\common_code\survey_lines.pas' {GetTracjksForm},
  DEMPersw in '..\common_code\DEMPersw.pas' {ThreeDview},
  demambushparams in '..\common_code\demambushparams.pas' {PickAmbushParams},
  demdbfilter in '..\common_code\demdbfilter.pas' {dbFilterCreation},
  tersplsh in '..\common_code\tersplsh.pas' {TerBaseSplashForm},
  basemap in '..\microdem_open_source\basemap.pas',
  DataBaseCreate in '..\microdem_open_source\DataBaseCreate.pas',
  dem_3d_view in '..\microdem_open_source\dem_3d_view.pas',
  dem_manager in '..\microdem_open_source\dem_manager.pas',
  demdef_routines in '..\microdem_open_source\demdef_routines.pas',
  demdefs in '..\microdem_open_source\demdefs.pas',
  petmar in '..\microdem_open_source\petmar.pas',
  petmar_types in '..\microdem_open_source\petmar_types.pas',
  PETMath in '..\microdem_open_source\PETMath.pas',
  PETImage in '..\microdem_open_source\PETImage.pas',
  geotiff in '..\microdem_open_source\geotiff.pas',
  Make_tables in '..\microdem_open_source\Make_tables.pas',
  PetDBUtils in '..\microdem_open_source\PetDBUtils.pas',
  DEMESRIShapeFile in '..\microdem_open_source\DEMESRIShapeFile.pas',
  demlos_draw in '..\microdem_open_source\demlos_draw.pas',
  demmagvar in '..\microdem_open_source\demmagvar.pas',
  DEMEros in '..\microdem_open_source\DEMEros.pas',
  grayscale_shift in '..\common_code\grayscale_shift.pas' {GrayscaleForm},
  dbf in '..\tdbf_current\dbf.pas',
  dbf_ansistrings in '..\tdbf_current\dbf_ansistrings.pas',
  dbf_avl in '..\tdbf_current\dbf_avl.pas',
  dbf_collate in '..\tdbf_current\dbf_collate.pas',
  dbf_common in '..\tdbf_current\dbf_common.pas',
  dbf_cursor in '..\tdbf_current\dbf_cursor.pas',
  dbf_dbffile in '..\tdbf_current\dbf_dbffile.pas',
  dbf_fields in '..\tdbf_current\dbf_fields.pas',
  dbf_idxcur in '..\tdbf_current\dbf_idxcur.pas',
  dbf_idxfile in '..\tdbf_current\dbf_idxfile.pas',
  dbf_lang in '..\tdbf_current\dbf_lang.pas',
  dbf_memo in '..\tdbf_current\dbf_memo.pas',
  dbf_parser in '..\tdbf_current\dbf_parser.pas',
  dbf_pgcfile in '..\tdbf_current\dbf_pgcfile.pas',
  dbf_pgfile in '..\tdbf_current\dbf_pgfile.pas',
  dbf_prscore in '..\tdbf_current\dbf_prscore.pas',
  dbf_prsdef in '..\tdbf_current\dbf_prsdef.pas',
  dbf_prssupp in '..\tdbf_current\dbf_prssupp.pas',
  dbf_str in '..\tdbf_current\dbf_str.pas',
  dbf_wtil in '..\tdbf_current\dbf_wtil.pas',
  ScreenUnicode in '..\UnicodeViewer-Duibhin\ScreenUnicode.pas' {FormUnicode},
  UnicodeLibrary in '..\UnicodeViewer-Duibhin\UnicodeLibrary.pas',
  NyqGraph in '..\nyquist\NyqGraph.pas' {NyquistBaseGraph},
  map_splitter in '..\common_code\map_splitter.pas' {splitter_form},
  color_filter in '..\common_code\color_filter.pas' {ColorFilterForm},
  view3d_main in '..\viewer_3d\view3d_main.pas' {View3DForm},
  new_dem_headerf in '..\common_code\new_dem_headerf.pas' {DEMHeaderForm},
  weapons_fan_thread in '..\microdem_open_source\weapons_fan_thread.pas',
  md_use_tools in '..\microdem_open_source\md_use_tools.pas',
  monthly_grids in '..\common_code\monthly_grids.pas' {GridTimeSeriesControlForm},
  petmar_db in '..\microdem_open_source\petmar_db.pas',
  petmar_geology in '..\microdem_open_source\petmar_geology.pas',
  lcp_options in '..\common_code\lcp_options.pas' {LCP_form},
  slider_sorter_form in '..\slide_sorter\slider_sorter_form.pas' {SlideSorterForm},
  dragon_plot_init in '..\dragonplot_only_code\dragon_plot_init.pas',
  dp_control in '..\dragonplot_only_code\dp_control.pas' {DragonPlotForm},
  lidar_multiple_grid_display in '..\las_lidar\lidar_multiple_grid_display.pas' {LidarMultipleDisplayForm},
  petmar_ini_file in '..\microdem_open_source\petmar_ini_file.pas',
  icesat_filter_form in '..\common_code\icesat_filter_form.pas' {Icesat_filter},
  demsatmerge in '..\common_code\demsatmerge.pas' {IHSMergeForm},
  dem_computations in '..\common_code\dem_computations.pas',
  aspect_colors in '..\common_code\aspect_colors.pas' {AspectMapColors},
  gdal_tools in '..\microdem_open_source\gdal_tools.pas',
  fat_fingers in '..\nyquist\fat_fingers.pas' {fat_fingers_form},
  new_petmar_movie in '..\movie\new_petmar_movie.pas' {FormAnimate},
  CCR.Exif.BaseUtils in '..\xif\CCR.Exif.BaseUtils.pas',
  CCR.Exif.Consts in '..\xif\CCR.Exif.Consts.pas',
  CCR.Exif.Demos in '..\xif\CCR.Exif.Demos.pas',
  CCR.Exif.IPTC in '..\xif\CCR.Exif.IPTC.pas',
  CCR.Exif.JpegUtils in '..\xif\CCR.Exif.JpegUtils.pas',
  CCR.Exif in '..\xif\CCR.Exif.pas',
  CCR.Exif.StreamHelper in '..\xif\CCR.Exif.StreamHelper.pas',
  CCR.Exif.TagIDs in '..\xif\CCR.Exif.TagIDs.pas',
  CCR.Exif.TiffUtils in '..\xif\CCR.Exif.TiffUtils.pas',
  CCR.Exif.XMPUtils in '..\xif\CCR.Exif.XMPUtils.pas',
  JpegDumpForm in '..\xif\JpegDumpForm.pas' {NewfrmJpegDump},
  JpegDumpOutputFrame in '..\xif\JpegDumpOutputFrame.pas' {NewOutputFrame: TFrame},
  U_SolarPos2 in '..\SolarPosSource\U_SolarPos2.pas' {SolorPosForm1},
  ufrmMain in '..\FireMonkey3DGlobalRotate\ufrmMain.pas' {frmMain},
  demix_filter in '..\demix\demix_filter.pas' {DemixFilterForm},
  monitor_change_form in '..\common_code\monitor_change_form.pas' {ChangeMapForm},
  pick_several_dems in '..\common_code\pick_several_dems.pas' {tPickGridsForm},
  tiger_address in '..\gis_ops\tiger_address.pas' {TigerAddressForm},
  demix_cop_alos in '..\demix\demix_cop_alos.pas',
  DEM_NLCD in '..\common_code\DEM_NLCD.pas',
  demix_definitions in '..\demix\demix_definitions.pas',
  demix_control in '..\demix\demix_control.pas',
  demix_graphs in '..\demix\demix_graphs.pas',
  demix_evals_scores_graphs in '..\demix\demix_evals_scores_graphs.pas' {eval_scores_graph_form},
  pick_demix_mode in '..\demix\pick_demix_mode.pas' {PickDEMIXmodeForm},
  ssim_fuv_control in '..\demix\ssim_fuv_control.pas' {fuv_ssim_control},
  pick_demix_areas in '..\demix\pick_demix_areas.pas' {PickAreasForm},
  SGP_CONV in '..\sgp\SGP_CONV.PAS',
  Sgp_in in '..\sgp\Sgp_in.pas',
  Sgp_init in '..\sgp\Sgp_init.pas',
  SGP_INTF in '..\sgp\SGP_INTF.PAS',
  SGP_MATH in '..\sgp\SGP_MATH.PAS',
  SGP_OBS in '..\sgp\SGP_OBS.PAS',
  SGP_OUT in '..\sgp\SGP_OUT.PAS',
  SGP_TIME in '..\sgp\SGP_TIME.PAS',
  SGP4SDP4 in '..\sgp\SGP4SDP4.PAS',
  SGP_Support in '..\sgp\SGP_Support.pas',
  edit_exif_fields in '..\common_code\edit_exif_fields.pas' {Form1},
  compare_geo_utm in '..\common_code\compare_geo_utm.pas' {compare_geo_utm_geomorphometry},
  demmapdraw in '..\mapdraw\demmapdraw.pas',
  demcoord in '..\demcoord\demcoord.pas',
  Demmapf in '..\mapform\Demmapf.pas' {MapForm},
  DEMDataBase in '..\database\DEMDataBase.pas' {GISdataBaseModule: TDataModule},
  SOLAR in '..\sgp\SOLAR.PAS',
  demssocalc in '..\geomorph\demssocalc.pas' {SSOCalcDlg},
  DEMStat in '..\geomorph\DEMStat.pas',
  geomorph_point_class in '..\geomorph\geomorph_point_class.pas' {PointClassForm},
  geomorph_region_size_graph in '..\geomorph\geomorph_region_size_graph.pas' {regionsizeform},
  pick_geostats in '..\geomorph\pick_geostats.pas' {PickGeoStat},
  compare_programs_algorithms in '..\geomorph\compare_programs_algorithms.pas',
  compare_algorithms_options in '..\geomorph\compare_algorithms_options.pas' {AlgCompareForm},
  DEMdbTable in '..\database\DEMdbTable.pas' {dbtablef},
  point_cloud_memory in '..\las_lidar\point_cloud_memory.pas',
  point_cloud_options in '..\las_lidar\point_cloud_options.pas' {pt_cloud_opts_fm},
  las_files_grouping in '..\las_lidar\las_files_grouping.pas',
  las_lidar in '..\las_lidar\las_lidar.pas';

{$R *.RES}

{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}
 

var
  FMutex: THandle;
begin
  FMutex := CreateMutex(nil, True, 'OneInstanceMutex');
  if (FMutex = 0) then begin
    RaiseLastOSError;
  end
  else begin
    try
      if false and (GetLastError = ERROR_ALREADY_EXISTS) then begin
        MessageToContinue('Program already running.  Closing...');
      end
      else begin
         {$IfDef MessageStartUpProblems} MessageToContinue('Startup microdem.dpr'); {$EndIf}
         ReportMemoryLeaksOnShutdown := (DebugHook <> 0);
         Application.Initialize;
         Application.Title := '';
         Application.HelpFile := 'microdem.chm';
         Application.CreateForm(Twmdem, wmdem);
  Application.Run;
      end;
    finally
       CloseHandle(FMutex);
    end;
  end;
end.



