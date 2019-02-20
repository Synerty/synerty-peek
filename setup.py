import os
import shutil

from setuptools import find_packages, setup

pip_package_name = "synerty-peek"
package_version = '1.1.9'

egg_info = "%s.egg-info" % pip_package_name
if os.path.isdir(egg_info):
    shutil.rmtree(egg_info)

if os.path.isfile('MANIFEST'):
    os.remove('MANIFEST')

requirements = [
    "peek-plugin-base",
    "peek-platform",
    "peek-agent",
    "peek-desktop",
    "peek-worker",
    "peek-mobile",
    "peek-client",
    "peek-doc-user",
    "peek-admin",
    "peek-doc-admin",
    "peek-server",
    "synerty-peek",
    "peek-core-email",
    "peek-core-device"
]

# Force the dependencies to be the same branch
reqVer = '.'.join(package_version.split('.')[0:2]) + ".*"

requirements = ["%s==%s" % (pkg, reqVer) for pkg in requirements]

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
    zip_safe=False, version=package_version,
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
