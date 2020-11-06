extends InteractionManager

func receive_interaction():
	RunManager.initiate_run(RunManager.target_era)
