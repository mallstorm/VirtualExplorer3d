extends Node3D

@export var fog_enabled := true
@export var fog_density := 0.035
@export var dust_particles_enabled := true

func apply_to_environment(environment: Environment) -> void:
	if environment == null:
		return
	environment.fog_enabled = fog_enabled
	environment.fog_density = fog_density

