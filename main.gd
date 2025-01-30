extends Node

@export var mob_scene: PackedScene


func _on_mob_timer_timeout() -> void:
    var mob: Node3D = mob_scene.instantiate()
    var mob_spawn_location_node: PathFollow3D = get_node("SpawnPath/SpawnLocation")
    mob_spawn_location_node.progress_ratio = randf()

    var player_position: Vector3 = $Player.position
    mob.initialize(mob_spawn_location_node.position, player_position)
    
    mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

    add_child(mob)


func _on_player_hit() -> void:
    $MobTimer.stop()
