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
	var attributes: Array[VertexAttribute]
	var vertex_attributes_offset: int
	var position_data_offset: int
	var normal_data_offset: int
	
	func _init(file: FileAccess):
		var chunk_start = file.get_position() - 8
		vertex_attributes_offset = file.get_32()
		position_data_offset = file.get_32()
		normal_data_offset = file.get_32()
		
		file.seek(chunk_start + vertex_attributes_offset)
		for _i in 256: # TODO: Something better that's not a `while true` loop
			var attribute := VertexAttribute.new(file)
			if attribute.type == VertexAttribute.AttributeType.NULL:
				break
			attributes.append(attribute)
	
	
	class VertexAttribute extends RefCounted:
		var type: AttributeType
		var component_count: int
		var component_type: int
		var component_shift: int
		
		enum AttributeType {
			POSITION = 0x09,
			NORMAL,
			NULL = 0xff,
		}
		
		
		func _init(file: FileAccess):
			type = file.get_32()
			component_count = file.get_32()
			component_type = file.get_32()
			component_shift = file.get_8()
			file.get_buffer(3)
