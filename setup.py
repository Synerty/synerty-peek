import os
import shutil

from setuptools import find_packages, setup

pip_package_name = "synerty-peek"
package_version = '0.5.0.1'

egg_info = "%s.egg-info" % pip_package_name
if os.path.isdir(egg_info):
    shutil.rmtree(egg_info)

if os.path.isfile('MANIFEST'):
    os.remove('MANIFEST')

requirements = [
    "peek-server",
    "peek-worker",
    "peek-agent",
    "peek-client"
]

doc_requirements = [
    "Sphinx",
    "Sphinx_rtd_theme",
    "sphinx-autobuild",
    "pytmpdir"
]

requirements.extend(doc_requirements)

setup(
    name=pip_package_name,
    packages=find_packages(exclude=["*.tests", "*.tests.*", "tests.*", "tests"]),
    install_requires=requirements,
    zip_safe=False,version=package_version,
    description='Peek Platform - Meta Package to install all services',
    author='Synerty',
    author_email='contact@synerty.com',
    url='https://github.com/Synerty/%s' % pip_package_name,
    download_url='https://github.com/Synerty/%s/tarball/%s' % (
        pip_package_name, package_version),
    keywords=['Peek', 'Python', 'Platform', 'synerty'],
    classifiers=[
        "Programming Language :: Python :: 3.5",
    ],
)
