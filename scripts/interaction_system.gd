extends Node

func inspect(object: Object) -> Variant:
	if object != null and object.has_method("get_interaction_data"):
		return object.get_interaction_data()
	if object != null and object.has_method("get_info"):
		return object.get_info()
	return null
