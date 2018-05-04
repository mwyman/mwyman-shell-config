"""mjw

Michael Wyman's specific Mercurial extensions.
"""

import os

from mercurial import commands
from mercurial import cmdutil
from mercurial import error
from mercurial import ui as uimod

cmdtable = {}
command = cmdutil.command(cmdtable)

CONFIG_SECTION='mjw'

@command('mjw', [], '[options]')
def mjw_main(ui, repo, **opts):
    """General extension method."""
    pass