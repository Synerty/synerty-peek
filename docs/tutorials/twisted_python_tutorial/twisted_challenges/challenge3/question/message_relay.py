from io import StringIO
import os

from twisted.internet.defer import Deferred
from twisted.trial import unittest
from unittest.mock import patch


def callback1(result):
    print("Person 1 said:", result)
    return result


def callback2(result):
    print("Person 2 said:", result)


def callback3(result):
    raise Exception("Person 3 blames!")


def errback1(failure):
    print("Person 1 had a blame on", failure)
    return failure


def errback2(failure):
    raise Exception("Person 2 blames!")


def errback3(failure):
    print("Person 3 took care of", failure)
    return "Everything is fine now."


# Q1: add a function to this function below to stop Person 3 blaming.
def q1():
    d = Deferred()
    d.addCallback(callback1)
    d.addCallback(callback2)
    d.addCallback(callback3)
    #
    # your code starts here
    #
    #
    # your code ends here
    #
    d.callback("Hello")


# Q2: make the message pass through Person 2 without Person 1 blaming
def q2():
    d = Deferred()
    # Person 3 blames first
    d.addCallback(callback3)
    #
    # your code starts here
    # hint: Person 3 handles it before Person 2 gets it and blames again
    #
    #
    # your code ends here
    #
    # Person 1 get correct message with no blames
    d.addCallbacks(callback1)
    d.callback("Test")


class RelayMessageQuestions(unittest.TestCase):
    @patch("sys.stdout", new_callable=StringIO)
    def testQ1(self, mockStdout):
        q1()

        actual = mockStdout.getvalue()
        expected = (
            "Person 1 said: Hello{n}Person 2 said: Hello{n}Person 3 took care of ["
            "Failure instance: Traceback: <class 'Exception'>: Person 3 blames!".format(
                n=os.linesep
            )
        )

        self.assertTrue(actual.startswith(expected))

    @patch("sys.stdout", new_callable=StringIO)
    def testQ2(self, mockStdout):
        q2()

        actual = mockStdout.getvalue()
        expectedHead = "Person 3 took care of [Failure instance: Traceback: <class 'Exception'>: Person 3 blames!{n}".format(
            n=os.linesep
        )
        expectedBottom = "Person 1 said: Everything is fine now.{n}".format(
            n=os.linesep
        )

        self.assertTrue(actual.startswith(expectedHead))
        self.assertTrue(actual.endswith(expectedBottom))


if __name__ == "__main__":
    import unittest as ut

    ut.main(RelayMessageQuestions())
