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

sub fieldnames {
    my ($self, $run, $args) = @_;
    my $c = _client();
    my $options = $run->options;
    my $parameters = $run->parameters;
    my $comp_param = $args->{parameter};
    my $fields = $options->{fields};
    my @possible = qw/
        status name date author maturity main_module id authorized
        archive version version_numified deprecated distribution
        abstract dependency license provides metadata resources stat
        tests
    /;
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
