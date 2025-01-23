extends Node

@export var mob_scene: PackedScene


func _on_mob_timer_timeout() -> void:
    var mob: Node = mob_scene.instantiate()
    var mob_spawn_location_node: Node = get_node("SpawnPath/SpawnLocation")
    mob_spawn_location_node.progress_ratio = randf()

    var player_position: Vector3 = $Player.position
    mob.initialize(mob_spawn_location_node.position, player_position)

    add_child(mob)
