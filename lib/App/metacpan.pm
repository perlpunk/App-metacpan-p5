use strict;
use warnings;
package App::metacpan;

our $VERSION = '0.000'; # VERSION

use 5.010;

use base 'App::Spec::Run::Cmd';

use MetaCPAN::Client;
use Data::Dumper;
#use WWW::Mechanize::Cached;
#use HTTP::Tiny::Mech;
#use CHI;

my $mcpan;
sub _client {
    $mcpan ||= MetaCPAN::Client->new(
#        ua => HTTP::Tiny::Mech->new(
#            mechua => WWW::Mechanize::Cached->new(
#                cache => CHI->new(
#                    driver   => 'File',
#                    root_dir => '/tmp/metacpan-cache',
#                ),
#            ),
#        ),
        debug => 1,
    );
    return $mcpan;
}

sub author_info {
    my ($self, $run) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $author = $c->author($parameters->{handle});
    my $data = $author->data;
    $run->out($data);
}

sub author_list {
    my ($self, $run) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $handle = $parameters->{handle};
    my @fields = qw/ pauseid name /;
    if ($options->{fields}) {
        my $fieldnames = $options->{fields};
        @fields = split m/,/, $fieldnames;
    }
    my $authors = $mcpan->author({
        pauseid => "$handle*",
    }, {
        sort => [{ pauseid => { order => 'asc' } }],
    });
    my @authors;
    while (my $item = $authors->next) {
        push @authors, {
            map { $_ => $item->$_ } @fields
        };
    }
    $run->out(\@authors);
}

sub author_releases {
    my ($self, $run) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $handle = $parameters->{handle};
    my @fields = qw/ name date /;
    if ($options->{fields}) {
        my $fieldnames = $options->{fields};
        @fields = split m/,/, $fieldnames;
    }

    my $author = $c->author($handle);
    my $format = $options->{format} // '';
    my $releases = $mcpan->release({
        all => [
            { author => $handle, },
            { status => 'latest', },
        ],
    }, {
        sort => [{ date => { order => 'desc' } }],
    });
    my @table = [map ucfirst @fields];
    my @list;
    while (my $release = $releases->next) {
        if ($format eq 'Table') {
            push @table, [map { $release->$_ } @fields];
        }
        else {
            push @list, {
                map { $_ => $release->$_ } @fields
            };
        }
    }
    if ($format eq 'Table') {
        $run->out(\@table);
    }
    else {
        $run->out(\@list);
    }
}

sub authors {
    my ($self, $run) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $handle = $parameters->{handle};
    unless (length $handle) {
        return ();
    }
    my $authors = $c->author( { pauseid => "$handle*" } );
    my @handles;
    while (my $item = $authors->next) {
        push @handles, $item->pauseid;
    }
    return \@handles;
}

sub module_info {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $modulename = $parameters->{module};
    my $module = $c->module($modulename)
        or die "Module $modulename not found";
    $run->out($module->data);
}

sub modules {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $modulename = $parameters->{module};
    unless (length $modulename) {
        return ();
    }
    my $modules = $c->module({ name => "$modulename*" })
        or die "Module $modulename not found";
    my @modules;
    while (my $item = $modules->next) {
        push @modules, $item->name;
    }
    return \@modules;
}

sub distribution_info {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $distname = $parameters->{distribution};
    my $dist = $c->distribution($distname)
        or die "Distribution $distname not found";
    $run->out($dist->data);
}

sub distributions {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $distriname = $parameters->{distribution};
    unless (length $distriname) {
        return ();
    }
    my $distris = $c->distribution({ name => "$distriname*" })
        or die "Distribution $distriname not found";
    my @distris;
    while (my $item = $distris->next) {
        push @distris, $item->name;
    }
    return \@distris;
}

sub release_info {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $distname = $parameters->{distribution};
    my $dist = $c->release($distname)
        or die "Distribution $distname not found";
    $run->out($dist->data);
}

sub favorite_info {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $distname = $parameters->{distribution};
    my $favorite = $c->favorite({ distribution => $distname })
        or die "Distribution $distname not found";
    $run->out($favorite->total);
}

sub favorite_list {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $distname = $parameters->{distribution};
    my @fields = qw/ release date author /;
    if ($options->{fields}) {
        my $fieldnames = $options->{fields};
        @fields = split m/,/, $fieldnames;
    }
    my @fav;
    my $favorite = $c->favorite({ distribution => $distname })
        or die "Distribution $distname not found";
    while (my $item = $favorite->next) {
        push @fav, { map { $_ => $item->$_ } @fields };
    }
    $run->out(\@fav);
}

my %commandfields = (
    "author releases" => [qw/
        status name date author maturity main_module id authorized
        archive version version_numified deprecated distribution
        abstract dependency license provides metadata resources stat
        tests
    /],
    release => [qw/
        status name date author maturity main_module id authorized
        archive version version_numified deprecated distribution
        abstract dependency license provides metadata resources stat
        tests
    /],
    "favorite list" => [qw/
        release date author user id distribution
    /],
    author => [qw/
        pauseid name ascii_name city region country updated dir
        gravatar_url user donation email website profile perlmongers
        links blog release_count extra
    /],
);
sub fieldnames {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $commands = $run->commands;
    my $parameters = $run->parameters;
    my $comp_param = $args->{parameter};
    my $fields = $options->{fields};
    my $possible = $commandfields{ "@$commands" } || [];
    my @possible = @$possible;
    my %possible;
    @possible{ @possible}  = ();
    my @complete;
    unless (length $fields) {
        @complete = @possible;
    }
    else {
        my %seen;
        my @seen = split m/,/, $fields, -1;
        my $last = pop @seen;
        for my $item (@seen) {
            $seen{ $item }++;
            delete $possible{ $item };
        }
        @possible = keys %possible;
        if ($possible{ $last }) {
        }
        else {
            @possible = grep { m/^\Q$last/ } @possible;
        }
        my $prefix = join ',', @seen;

        @complete = @seen ? (map { "$prefix,$_" } @possible) : @possible;
    }
    if (@complete == 1) {
        @complete = map { $_, "$_," } @complete;
    }
    else {
        @complete = map { "$_," } @complete;
    }
    return \@complete;
}

1;
