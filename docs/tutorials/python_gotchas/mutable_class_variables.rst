=======================
Mutable Class Variables
=======================


Description
-----------

::

    class C:
        var = []
        val = 0

        def __init__(self, val):
            self.var.append(val)
            self.val = val

    x = C(1)
    y = C(2)


What would be the output from printing the values of x and y?


Expected Result
---------------

::

    y.var: [1]
    y.val: 1

    y.var: [1, 2]
    y.val: 2

OR

::

    y.var: [1,2]
    y.val: 2

    y.var: [1, 2]
    y.val: 2


Actual Output
-------------

::

    y.var: [1, 2]
    y.val: 1

    y.var: [1, 2]
    y.val: 2


Why this causes confusion
-------------------------

Users who have become accustomed to other programming languages may expect that
Python's class instances would not share values unless those values were static. If
this were the case, :code:`x.val` would also be 2, as that is what :code:`y`
overwrote it to be.


What is happening
-----------------
Python default class variables behave similarly to static variables in other
languages, every individual instance of a class references the same class variable.
However, if a default value is overridden it becomes local to the instance instead
of overwriting the class variable.

Because there is a matching variable inside of the class, there is no need to keep
looking at a wider scope for it and so the class variable is never checked.

Because when it was initialised, :code:`x` modified :code:`var`, but overwrote
:code:`val`, it still sees the changes :code:`y` made to :code:`var`, but is not
affected by further changes to :code:`val`, as these would exist in the class scope
and not the instance scope.


Demonstration
-------------

::

    class C:
        var = []

        def __init__(self, x):
            self.var.append(x)

        def overrideVar(x):
            self.var = [x]

    x = C(1)
    y = C(2)
    y.overrideVar(x)
    z= C(4)

    print("x:", x.var)
    print("y:", y.var)
    print("z:", z.var)

Will output::

    x: [1, 2, 4]
    y: [3]
    z: [1, 2, 4]

Proving (because :code:`z` can still access it) that the class variable remains
unchanged, but that the variable in :code:`y`'s instance scope has been overridden.


