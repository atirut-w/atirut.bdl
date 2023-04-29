@tool
extends EditorImportPlugin


func _get_importer_name() -> String:
	return "atirut.bdl"


func _get_visible_name() -> String:
	return "Jsystem BMD/BDL"


func _get_recognized_extensions() -> PackedStringArray:
	return ["bmd", "bdl"]


func _get_save_extension() -> String:
	return "scn"


func _get_resource_type() -> String:
	return "PackedScene"


func _get_priority() -> float:
	return 1.0


func _get_preset_count() -> int:
	return 1


func _get_preset_name(preset_index: int) -> String:
	return "Default"


func _get_import_order() -> int:
	return ResourceImporter.IMPORT_ORDER_SCENE


func _get_import_options(path: String, preset_index: int) -> Array:
	return []


func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array, gen_files: Array) -> Error:
	var file := FileAccess.open(source_file, FileAccess.READ)
	var data := BDL.new(file)
	if not data.file_type.substr(0, 3).to_lower() in ["bmd", "bdl"]:
		return ERR_FILE_UNRECOGNIZED
	
	var root := Node3D.new()
	root.name = source_file.get_file().split(".")[0]
	
	var packed := PackedScene.new()
	packed.pack(root)
	return ResourceSaver.save(packed, "%s.%s" % [save_path, _get_save_extension()])
