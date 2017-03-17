

rootpath = path.abspath(rootpath)
excludes = normalize_excludes(rootpath, excludes)
modules = recurse_tree(rootpath, excludes, opts)
if opts.full:
    from sphinx import quickstart as qs

    modules.sort()
    prev_module = ''
    text = ''
    for module in modules:
        if module.startswith(prev_module + '.'):
            continue
        prev_module = module
        text += '   %s\n' % module
    d = dict(
        path=opts.destdir,
        sep=False,
        dot='_',
        project=opts.header,
        author=opts.author or 'Author',
        version=opts.version or '',
        release=opts.release or opts.version or '',
        suffix='.' + opts.suffix,
        master='index',
        epub=True,
        ext_autodoc=True,
        ext_viewcode=True,
        ext_todo=True,
        makefile=True,
        batchfile=True,
        mastertocmaxdepth=opts.maxdepth,
        mastertoctree=text,
        language='en',
        module_path=rootpath,
        append_syspath=opts.append_syspath,
    )
    if isinstance(opts.header, binary_type):
        d['project'] = d['project'].decode('utf-8')
    if isinstance(opts.author, binary_type):
        d['author'] = d['author'].decode('utf-8')
    if isinstance(opts.version, binary_type):
        d['version'] = d['version'].decode('utf-8')
    if isinstance(opts.release, binary_type):
        d['release'] = d['release'].decode('utf-8')
