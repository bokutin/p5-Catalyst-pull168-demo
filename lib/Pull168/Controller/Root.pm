package Pull168::Controller::Root;

use Moose;
BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    my $body = <<'';
        <a href="/english">english</a><br>
        <a href="/japanese">japanese</a><br>

    $c->res->body($body);
}

sub default :Private {
    my ($self, $c) = @_;
    $c->log->abort(1);
    $c->res->body('');
}

#
# Actually proxy to my private LAN.
#

use Plack::App::Proxy;
my $app = Plack::App::Proxy->new->to_app;
sub english :Local {
    my ($self, $c) = @_;
    $c->log->debug( "BEGIN:".$c->req->uri );
    my $env = $c->req->env;
    local $env->{'plack.proxy.url'} = "http://perldoc.perl.org/"; # Content-Type: text/html
    my $psgi_res = $app->($env);
    $c->res->from_psgi_response($psgi_res);
    $c->log->debug( "END:".$c->req->uri );
}

sub japanese :Local {
    my ($self, $c) = @_;
    $c->log->debug( "BEGIN:".$c->req->uri );
    my $env = $c->req->env;
    local $env->{'plack.proxy.url'} = "http://perldoc.jp/";       # content-type: text/html; charset=UTF-8
    my $psgi_res = $app->($env);
    $c->res->from_psgi_response($psgi_res);
    $c->log->debug( "END:".$c->req->uri );
}

__PACKAGE__->meta->make_immutable;
1;
