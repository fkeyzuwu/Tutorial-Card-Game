class_name Target extends Resource

@export var target_type := TargetType.Self
var card: Card

enum TargetType {
	Self,
	ActionCard,
	AffectedCard
}
