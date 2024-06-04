public class MassCloseExtension {

	public List<SObject> tasks;

	public MassCloseExtension(ApexPages.StandardSetController controller) {
		tasks = controller.getSelected();
	}

	public PageReference execute() {

		for (SObject t : tasks) {
			t.put('Status', 'Closed');
		}
		update tasks;
		system.debug(tasks);
		return new ApexPages.Action('{!List}').invoke();
	}
}