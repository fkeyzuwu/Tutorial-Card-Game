extends Node

func add_listener(event_type: GDScript, method: Callable):
	var event_name = event_type.type()
	
	if(!has_user_signal(event_name)):
		add_user_signal(event_name, [{ "name": "event_args", "type": TYPE_OBJECT }])
	
		
	connect(event_name, method)

func remove_listener(event_type: GDScript, method: Callable):
	var event_name = event_type.type()
	
	if(!has_user_signal(event_name)):
		return
	
	disconnect(event_name, method)

func invoke_event(event: Event):
	var event_name = event.type()
	if !has_user_signal(event_name):
		return
	
	emit_signal(event_name, event)
