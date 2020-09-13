===========================
List Iteration Modification
===========================


Description
-----------

::

    nums[1, 2, 3, 4, 3, 2, 1]
    print("Before:", nums)

    for ind, n in enumerate(nums):
        if n < 3:
            del(nums[ind])

    print("After:", nums)


Expected Result
---------------

::

    Expected: nums [3, 4, 3]


Actual Output
-------------

::

    After: [2, 3, 4, 3, 1]


Explanation
-----------

:code:`del` modifies in-place. When index 0 (value: 1) in :code:`nums` is deleted, index 1 (value: 2)
is moved down to index 0 to take its place BEFORE the iterator increments.
This allows the value 2 to be essentially skipped-over, despite being less than 3.

Instead, use list comprehension to create a new list that meets the same requirements.
