import shutil

import sphinx
from pytmpdir.Directory import Directory
from sphinx.apidoc import *


class _Opts:
    # 'Directory to place all output'
    destdir = None

    # 'file suffix (default: rst)', NO DOT '.'
    suffix = "rst"

    # 'Run the script without creating files'
    dryrun = False

    # 'Overwrite existing files'
    force = False

    # Don't create headings for the module/package
    # packages (e.g. when the docstrings already contain them)
    noheadings = False

    # 'Put module documentation before submodule documentation'
    modulefirst = True

    # 'Put documentation for each module on its own page'
    separatemodules = False

    # Follow symbolic links. Powerful when combined with collective.recipe.omelette.'
    followlinks = False

    # 'Interpret module paths according to PEP-0420 implicit namespaces specification'
    implicit_namespaces = False

    # 'Maximum depth of submodules to show in the TOC '
    maxdepth = 10

    # 'Include "_private" modules'
    includeprivate = False

    # 'Append module_path to sys.path, used when --full is given'
    append_syspath = True


def _listFiles(dir):
    ignoreFiles = set('.lastHash')
    paths = []
    for (path, directories, filenames) in os.walk(dir):

        for filename in filenames:
            if filename in ignoreFiles:
                continue
            paths.append(os.path.join(path[len(dir) + 1:], filename))

    return paths


def _fileCopier(src, dst):
    with open(src, 'rb') as f:
        contents = f.read()

    # If the contents hasn't change, don't write it
    if os.path.isfile(dst):
        with open(dst, 'rb') as f:
            if f.read() == contents:
                return

    with open(dst, 'wb') as f:
        f.write(contents)


def _syncFiles(srcDir, dstDir):
    if not os.path.isdir(dstDir):
        os.makedirs(dstDir)

    # Create lists of files relative to the dstDir and srcDir
    existingFiles = set(_listFiles(dstDir))
    srcFiles = set(_listFiles(srcDir))

    for srcFile in srcFiles:
        srcFilePath = os.path.join(srcDir, srcFile)
        dstFilePath = os.path.join(dstDir, srcFile)

        dstFileDir = os.path.dirname(dstFilePath)
        os.makedirs(dstFileDir, exist_ok=True)
        _fileCopier(srcFilePath, dstFilePath)

    for obsoleteFile in existingFiles - srcFiles:
        obsoleteFile = os.path.join(dstDir, obsoleteFile)

        if os.path.islink(obsoleteFile):
            os.remove(obsoleteFile)

        elif os.path.isdir(obsoleteFile):
            shutil.rmtree(obsoleteFile)

        else:
            os.remove(obsoleteFile)


def create_module_file(package, module, opts):
    """Build the text of the file and write the file."""
    raise Exception("create_module_file shouldn't get called")
    # text = format_heading(1, '(M) %s' % module)
    # # text += format_heading(2, ':mod:`%s` Module' % module)
    # text += format_directive(module, package)
    # write_file(makename(package, module), text, opts)


def create_package_file(root, master_package, subroot, py_files, opts, subs,
                        is_namespace):
    """Build the text of the file and write the file."""

    text = '.. _%s:\n\n' % makename(master_package, subroot)

    text += format_heading(1, '(P) %s' % subroot if subroot else master_package)
    text += format_directive(subroot, master_package)
    text += '\n'

    # build a list of directories that are szvpackages (contain an INITPY file)
    subs = [sub for sub in subs if path.isfile(path.join(root, sub, INITPY))]
    # if there are some package directories, add a TOC for theses subpackages

    if subs:
        text += '.. toctree::\n\n'
        for sub in subs:
            text += '    %s.%s\n' % (makename(master_package, subroot), sub)
        text += '\n'

    submods = [path.splitext(sub)[0] for sub in py_files
               if not shall_skip(path.join(root, sub), opts) and
               sub != INITPY]

    for submod in submods:
        text += format_heading(2, '(M) %s' % submod)
        text += format_directive(makename(subroot, submod), master_package)
        text += '\n'

    text += '\n'

    write_file(makename(master_package, subroot), text, opts)

def is_excluded(root, excludes):
    """Check if the directory is in the exclude list.

    Note: by having trailing slashes, we avoid common prefix issues, like
          e.g. an exlude "foo" also accidentally excluding "foobar".
    """

    fileName = os.path.basename(root)
    dirName = os.path.dirname(root)

    excludes = ['Test.py', 'setup.py']

    for exclude in excludes:
        if fileName.endswith(exclude):
            return True

    return False

# Overwrite the apidoc render methods with ours
sphinx.apidoc.create_package_file = create_package_file
sphinx.apidoc.create_module_file = create_module_file
sphinx.apidoc.is_excluded = is_excluded

def createApiDocs(modFileName):
    moduleName = os.path.basename(os.path.dirname(modFileName))

    rootpath = path.abspath(path.dirname(modFileName))
    realDstDir = os.path.join(os.path.dirname(__file__), "api_autodoc", moduleName)

    tmpDir = Directory()

    opts = _Opts()
    opts.destdir = tmpDir.path

    if not os.path.isdir(opts.destdir):
        os.makedirs(opts.destdir)

    modules = recurse_tree(rootpath, [], opts)
    # create_modules_toc_file(modules, opts)


    # Incrementally update files
    _syncFiles(tmpDir.path, realDstDir)
