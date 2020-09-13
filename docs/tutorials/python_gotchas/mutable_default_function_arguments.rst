==================================
Mutable Default Function Arguments
==================================


Description
-----------

::

    def func(val, arg1=[], arg2={}):
        arg1.append(val)
        arg2[val] = str(val)
        print("arg1:", arg1)
        print("arg2:", arg2)
    func(1)
    func(2)
    func('c')


What does the function print on the call to :code:`func('c')`?

Expected Result
---------------

::

    arg1: ['c']
    arg2: {'c':'c'}


Actual Result
-------------
::

    arg1: [1, 2, 'c']
    arg2: {1: '1', 2: '2', 'c': 'c'}


Explanation
-----------

Default function arguments in Python are persistent. The function is created once and then called
multiple times. The default arguments are mutable, so despite being persistent they can be
overwritten.

If your intention is to have the default values created fresh each time, then one
option would be to give the default argument a value of None and then use an if check to set it to
what is wanted::

    def func(val, arg1=None, arg2=None):

        # Set the arguments to the desired defaults here
        if arg1 is None:
            arg1 = []
        if arg2 is None:
            arg2 = {}

        arg1.append(val)
        arg2[val] = str(val)

This would give the original expected output of::

    arg1: ['c']
    arg2: {'c':'c'}


