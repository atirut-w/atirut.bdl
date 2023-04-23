class_name JSystemBinary
extends RefCounted
## Class for storing information about a JSystem binary file.


## Indicates what JSystem library this file is used by.
var subsystem_version: String
## The kind of file.
var file_type: String
## Total size of the file.
var file_size: int
## The number of chunks in the file.
var chunk_count: int
## Usually ignored. Probably used to track data migration during development.
var subversion: String

## Chunks contained in this file.
var chunks: Array[JSystemChunk]


func _init(file: FileAccess):
	file.big_endian = true # Just to be sure
	subsystem_version = file.get_buffer(4).get_string_from_ascii()
	file_type = file.get_buffer(4).get_string_from_ascii()
	file_size = file.get_32()
	chunk_count = file.get_32()
	subversion = file.get_buffer(4).get_string_from_ascii()
	file.get_buffer(12) # Padding

	print("Loading %s: subsystem version %s, type %s with %d chunks" % [file.get_path().get_file(), subsystem_version, file_type, chunk_count])

	for i in chunk_count:
		var chunk := JSystemChunk.new()
		chunk.type = file.get_buffer(4).get_string_from_ascii()
		chunk.size = file.get_32()
		chunk.data_offset = file.get_position()

		chunks.append(chunk)
		file.seek((chunk.data_offset + chunk.size) - 8)

		print("Loaded chunk '%s'(%s)" % [chunk.type, String.humanize_size(chunk.size)])


class JSystemChunk extends RefCounted:
	## The type of this chunk.
	var type: String
	## The size of this chunk.
	var size: int
	## The offset of this chunk's data past its header.
	var data_offset: int
