"""mjw

Michael Wyman's specific Mercurial extensions.
"""

import os

from mercurial import commands
from mercurial import cmdutil
from mercurial import registrar
from mercurial import error
from mercurial import ui as uimod

cmdtable = {}
command = registrar.command(cmdtable)

CONFIG_SECTION=b'mjw'

@command(b'mjw', [], b'[options]')
def mjw_main(ui, repo, **opts):
    """General extension method."""
    pass
