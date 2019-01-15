use strict;
use warnings;

use Pull168;

my $app = Pull168->apply_default_middlewares(Pull168->psgi_app);
$app;
