# Towards bringing requirements and development closer

This project provides a practical solution for IDE-integrated requirements engineering.

## How to Load

Run this code snippet in the playground of Pharo 8.0 and you will have access to the code.
```
Metacello new
  baseline: 'Epic';
  repository: 'github://nitishspatkar/SCG_EpicGit';
  load
```

## Quick Example
Type in the following code in the Playground and run it:
```
EpicExamples new requirementContainerWithThreeEpics.
```
This code generates a requirement container and populates it with a set of requirements artifacts.
Navigate through the different views in the container element to see the representations of the artifacts within.

## Manual
### ERequirementContainer
To set up a new requirement container, type in this code:
```
ERequirementContainer new
  project: 'MyApp'.
```
a project name can be specified. 

Once executed, a window appears with the container's interface.
The bar with tabs on the top of the window lists the GtViews associated with the container.
The first view, 'View Details', introduces the implemented artifacts and other views for the container.

### Mind Map Visualization
The second view, 'Mind Map', visualizes the artifacts in a graph. It also allows artifacts to be added to the container.
At first, epics have to be added. This is done through the 'Add Epic' button on the top of the graph pane, in the button bar.
A form appears with the inputs needed for the epic.
After puttin in the data and clicking the 'Save' button, the user is returned to the view, with the newly added epic.
From there, users can hover over the epic node and display a tooltip window. 
This allows users to edit the epic, remove it, and add a 'sub-element' to it - in the cas of epics, a use case. A similar input form appears.
After saving the data, the use case appears, with a connection to the epic, and a different node border color to indicate the type of artifact.
Similarly, the tooltips are used to create user stories and scenarios.
Upon adding a user story, the background color of the nodes changes - user stories incorporate the notion of work states.
When a new user story is added to the container, its initial state is 'Not started', and the associated node color is red.
User stories also can be assigned implementation points, which impact the size of their nodes - the more points associated with a story, the bigger its node.
Parent elements, i.e. use cases and epics, aggregate the node sizes and background colors of their associated user stories.

### User Story Wall
Changing the work states of user stories can be done through the 'Story Wall' view of the container.
Click the 'Change status' button of a user story (represented by a story card) to change its work state.
Return to the 'Mind Map' view and refresh it (button in the top right corner of the graph pane) to reflect these changes in the mind map.

### Linking requirements with source code
Each user story has a field called 'description'. It is meant to be a short, natural language description of the story (e.g. A user should be able to add a contact to an address book). 
The description can be edited in the 'Description' view of a user story.
The description can be enhanced with references to code entities.
This is done by enclosing text in a special syntax, like so:
Contact -> ${class:name=Contact}$.
This transform the word 'Contact' into a reference to a class called Contact. Clicking the tickmark button ('Save') saves the changes to the description.
A list of the created references can be seen in the 'Referenced Entities' view of a user story, use case and epic.
A list view shows the referenced entities, and also denotes if a referenced class is not implemented - in such a case, the list item is appended with the text ' - missing'.
In such cases, the class can be added quickly using the class addition menu, which can be opened by clicking the plus button to the right of a missing reference.
An input menu appears with input data for the class.
Upon saving this data, the class is created and the view is updated.
Clicking on a reference takes the user to the class itself.

Similarly, each class in the environment implements a reference view, called 'Requirement References'.
It shows a list of requirements that reference the class.
Clicking on a reference takes the user to the requirement, thus completing the two-way navigation between source code and requirements.
