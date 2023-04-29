class_name BDL
extends JSystemBinary

var matrix_group_count: int
var vertex_count: int
var vertex_data: VertexData

func _init(file: FileAccess):
	super(file)
	
	file.seek(chunks[0].data_offset)
	file.get_32()
	matrix_group_count = file.get_32()
	vertex_count = file.get_32()
	
	file.seek(chunks[1].data_offset)
	vertex_data = VertexData.new(file)


class VertexData extends RefCounted:
	var position_data_offset: int
	var normal_data_offset: int
	
	
	func _init(file: FileAccess):
		file.get_32()
		position_data_offset = file.get_32()
		normal_data_offset = file.get_32()
