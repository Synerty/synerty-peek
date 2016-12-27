import os
import shutil
from distutils.core import setup

from setuptools import find_packages

package_name = "synerty-peek"
package_version = '0.0.7'

egg_info = "%s.egg-info" % package_name
if os.path.isdir(egg_info):
    shutil.rmtree(egg_info)

requirements = [
    "peek-server",
    "peek-worker",
    "peek-agent",
    "peek-client"
]

setup(
    name=package_name,
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    install_requires=requirements,
    version=package_version,
    description='Peek Platform - Meta Package to install all services',
    author='Synerty',
    author_email='contact@synerty.com',
    url='https://github.com/Synerty/%s' % package_name,
    download_url='https://github.com/Synerty/%s/tarball/%s' % (
        package_name, package_version),
    keywords=['Peek', 'Python', 'Platform', 'synerty'],
    classifiers=[
        "Programming Language :: Python :: 3.5",
    ],
)
