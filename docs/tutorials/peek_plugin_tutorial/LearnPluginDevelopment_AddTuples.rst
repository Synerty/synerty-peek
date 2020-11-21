.. _learn_plugin_development_add_tuples:

==========
Add Tuples
==========

In this document, define tuples in Python and TypeScript. A Tuple is a defined class
in TypeScript (javascript) or Python.

These are not to be confused with the :code:`tuple` python built in type.

What are it's purposes:

#.  We can work with first class objects :code:`t1.string1`, VS dicts of attributes
    :code:`t1["string1"]`.

#.  We can add additional methods to the Tuple classes that
    would not otherwise be available, EG :code:`t1.formattedStringInt()`

#.  Defining Tuples simplifies sending data between serv ices via the vortex,
    If a Tuple object is sent on one end, it will be a Tuple object
    when it's deserailised on the other end.

.. important::  It's important to import all the tuples when the plugin is loaded
                on each Peek python service (worker, field, office, logic and agent).

                The plugin loading code will throw errors if one of our Tuples is
                imported first by another plugin and not by us.

Objective
---------

In this procedure we'll do the following:

#.  Create a Tuple in Python and register it.

#.  Create a Tuple in TypeScript and register it.

#.  Create a StringIntTuple in TypeScript and register it.

Tuples File Structure
---------------------

Add Package :file:`_private.tuples`
```````````````````````````````````

The :file:`_private.tuples` python package will contain the private python Tuples.

----

Create the :file:`peek_plugin_tutorial/_private/tuples` package, with
the commands ::

        mkdir peek_plugin_tutorial/_private/tuples
        touch peek_plugin_tutorial/_private/tuples/__init__.py

.. _learn_plugin_development_add_tuples_tutorial_tuple_py:

Add File :file:`TutorialTuple.py`
`````````````````````````````````

The :file:`TutorialTuple.py` defines a simple class that we use to work with data.
This is serialisable by the Vortex.

----

Create the file
:file:`peek_plugin_tutorial/_private/tuples/TutorialTuple.py`
and populate it with the following contents.

::

        from vortex.Tuple import Tuple, addTupleType, TupleField

        from peek_plugin_tutorial._private.PluginNames import tutorialTuplePrefix


        @addTupleType
        class TutorialTuple(Tuple):
            """ Tutorial Tuple

            This tuple is a create example of defining classes to work with our data.
            """
            __tupleType__ = tutorialTuplePrefix + 'TutorialTuple'

            #:  Description of date1
            dict1 = TupleField(defaultValue=dict)

            #:  Description of date1
            array1 = TupleField(defaultValue=list)

            #:  Description of date1
            date1 = TupleField()



Edit File :file:`_private/tuples/__init__.py`
`````````````````````````````````````````````

In this step, we add a setup method on the tuples package, this setup method
then loads all the handlers needed for the backend.

----

Edit file :file:`peek_plugin_tutorial/_private/tuples/__init__.py`
Add the following: ::

        from txhttputil.util.ModuleUtil import filterModules


        def loadPrivateTuples():
            """ Load Private Tuples

            In this method, we load the private tuples.
            This registers them so the Vortex can reconstructed them from
            serialised data.

            """
            for mod in filterModules(__name__, __file__):
                __import__(mod, locals(), globals())



Add Package :file:`tuples`
``````````````````````````

The :file:`tuples` python package will contain the public python Tuples.
The tuples which our plugin wants to share with other plugins.

We won't define any public tuples here, but we'll set it up.

See more at :ref:`learn_plugin_development_add_plugin_python_apis`.

----

Create the :file:`peek_plugin_tutorial/tuples` package, with
the commands ::

        mkdir peek_plugin_tutorial/tuples
        touch peek_plugin_tutorial/tuples/__init__.py



Edit File :file:`tuples/__init__.py`
````````````````````````````````````

In this step, we add a setup method on the tuples package, this setup method
then loads all the handlers needed for the backend.

----

Edit file :file:`peek_plugin_tutorial/tuples/__init__.py`
Add the following: ::

        from txhttputil.util.ModuleUtil import filterModules


        def loadPublicTuples():
            """ Load Public Tuples

            In this method, we load the public tuples.
            This registers them so the Vortex can reconstructed them from
            serialised data.

            """

            for mod in filterModules(__name__, __file__):
                __import__(mod, locals(), globals())



.. _learn_plugin_development_add_tuples_edit_logic_entry_hook:

Edit File :file:`LogicEntryHook.py`
``````````````````````````````````````````

Now, we need to load all our Tuples when the plugin is loaded, for every service.
To do this, we call the methods we've added to the :code:`tuple` packages above.

----

Edit file :file:`peek_plugin_tutorial/_private/logic/LogicEntryHook.py` :

#.  Add this import up the top of the file ::

        from peek_plugin_tutorial._private.tuples import loadPrivateTuples
        from peek_plugin_tutorial.tuples import loadPublicTuples

#.  Add this line after the docstring in the :code:`load()` method ::

        loadPrivateTuples()
        loadPublicTuples()

The method should now look similar to this ::

        def load(self):
            ...
            loadStorageTuples() # This line was added in the "Add Storage" guide
            loadPrivateTuples()
            loadPublicTuples()
            logger.debug("Loaded")


.. note:: If you see a message like this in the log:
    :code:`Tuple type |%s| not registered within this program.`
    The above steps haven't been completed properly and there is a problem with the
    tuple loading in the peek services.

Edit File :file:`FieldEntryHook.py`
``````````````````````````````````````````

This step applies if you're plugin is using the Field Service.

.. note:: This service was add earlier in this tutorial, see
    :ref:`learn_plugin_development_add_field_service`

Edit file :file:`peek_plugin_tutorial/_private/field/FieldEntryHook.py` file,
apply the same edits from step
:ref:`learn_plugin_development_add_tuples_edit_logic_entry_hook`.

Edit File :file:`OfficeEntryHook.py`
```````````````````````````````````````````

This step applies if you're plugin is using the Field Service.

.. note:: This service was add earlier in this tutorial, see
    :ref:`learn_plugin_development_add_office_service`

Edit file :file:`peek_plugin_tutorial/_private/office/OfficeEntryHook.py` file,
apply the same edits from step
:ref:`learn_plugin_development_add_tuples_edit_logic_entry_hook`.

Edit File :file:`AgentEntryHook.py`
```````````````````````````````````

This step applies if you're plugin is using the Agent service.

.. note:: This service was add earlier in this tutorial, see
    :ref:`learn_plugin_development_add_agent`

Edit file :file:`peek_plugin_tutorial/_private/agent/AgentEntryHook.py` file,
apply the same edits from step
:ref:`learn_plugin_development_add_tuples_edit_logic_entry_hook`.

Edit File :file:`WorkerEntryHook.py`

This step applies if you're plugin is using the Worker service.

.. note:: This service is added in this tutorial, see
    :ref:`learn_plugin_development_add_worker`

Edit file :file:`peek_plugin_tutorial/_private/worker/WorkerEntryHook.py` file,
apply the same edits from step
:ref:`learn_plugin_development_add_tuples_edit_logic_entry_hook`.

Test Python Services
--------------------

At this point all the python services should run, you won't see any differences but
it's a good idea to run them all and check there are no issues.

Tuples Frontends and TypeScript
-------------------------------

We now move onto the frontends, and TypeScript.

Add Directory :file:`plugin-module/_private/tuples`
```````````````````````````````````````````````````

The :file:`plugin-module/_private/tuples` directory will contain our example tuple,
written in TypeScript.

Our exampled tuple will be importable with: ::

        import {TutorialTuple} from "@peek/peek_plugin_tutorial";

----

Create directory :file:`peek_plugin_tutorial/plugin-module/_private/tuples`,
with command ::

        mkdir -p peek_plugin_tutorial/plugin-module/_private/tuples


.. _learn_plugin_development_add_tuples_tutorial_tuple_ts:

Edit File :file:`plugin_package.json`
`````````````````````````````````````

Edit the file :file:`plugin_package.json` to include reference to **plugin-module** inside the block **field** and
**admin**. Your file should look similar to the below: ::

        {
            "admin": {
                ...
                "moduleDir": "plugin-module"
            },
            "field": {
                ...
                "moduleDir": "plugin-module"
            },
            "office": {
                ...
                "moduleDir": "plugin-module"
            },
            ...

        }


Add File :file:`TutorialTuple.ts`
`````````````````````````````````

The :file:`TutorialTuple.ts` file defines a TypeScript class for our
:code:`TutorialTuple` Tuple.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/tuples/TutorialTuple.ts`,
with contents ::

        import {addTupleType, Tuple} from "@synerty/vortexjs";
        import {tutorialTuplePrefix} from "../PluginNames";


        @addTupleType
        export class TutorialTuple extends Tuple {
            public static readonly tupleName = tutorialTuplePrefix + "TutorialTuple";

            //  Description of date1
            dict1 : {};

            //  Description of array1
            array1 : any[];

            //  Description of date1
            date1 : Date;

            constructor() {
                super(TutorialTuple.tupleName)
            }
        }




Add File :file:`StringIntTuple.ts`
``````````````````````````````````

The :file:`StringIntTuple.ts` file defines the TypeScript Tuple for the
hybrid Tuple/SQL Declarative that represents :code:`StringIntTuple`.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/tuples/StringIntTuple.ts`,
with contents ::

        import {addTupleType, Tuple} from "@synerty/vortexjs";
        import {tutorialTuplePrefix} from "../PluginNames";


        @addTupleType
        export class StringIntTuple extends Tuple {
            public static readonly tupleName = tutorialTuplePrefix + "StringIntTuple";

            //  Description of date1
            id : number;

            //  Description of string1
            string1 : string;

            //  Description of int1
            int1 : number;

            constructor() {
                super(StringIntTuple.tupleName)
            }
        }



Add File :file:`SettingPropertyTuple.ts`
````````````````````````````````````````

The :file:`SettingPropertyTuple.ts` file defines the TypeScript Tuple for the
hybrid Tuple/SQL Declarative that represents :code:`SettingPropertyTuple`.

The :code:`SettingProperty` storage table is the in the :code:`storage/Settings.py` file,
It's the table that stores the key/value pairs.

----

Create file
:file:`peek_plugin_tutorial/plugin-module/_private/tuples/SettingPropertyTuple.ts`,
with contents ::

        import {addTupleType, Tuple} from "@synerty/vortexjs";
        import {tutorialTuplePrefix} from "../PluginNames";


        @addTupleType
        export class SettingPropertyTuple extends Tuple {
            // The tuple name here should end in "Tuple" as well, but it doesn't, as it's a table
            public static readonly tupleName = tutorialTuplePrefix + "SettingProperty";

            id: number;
            settingId: number;
            key: string;
            type: string;

            int_value: number;
            char_value: string;
            boolean_value: boolean;


            constructor() {
                super(SettingPropertyTuple.tupleName)
            }
        }



Edit File :file:`_private/index.ts`
```````````````````````````````````

The :file:`_private/index.ts` file will re-export the Tuple in a more standard way.
Developers won't need to know the exact path of the file.

----

Edit file :file:`peek_plugin_tutorial/plugin-module/_private/index.ts`,
Append the line: ::

        export {TutorialTuple} from "./tuples/TutorialTuple";
        export {StringIntTuple} from "./tuples/StringIntTuple";
        export {SettingPropertyTuple} from "./tuples/SettingPropertyTuple";

----

This document is complete.
