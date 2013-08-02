# -*- cperl -*-
# $Id$

##
# This test checks that unique_key works correctly.
# it relies on the success of t/01basic.t, t/02parse.t, and t/04node.t

use Test::More tests => 26;

use XML::LibXML;
use XML::LibXML::Common qw(:libxml);
use strict;
use warnings;
my $xmlstring = q{<foo>bar<foobar/><bar foo="foobar"/><!--foo--><![CDATA[&foo bar]]></foo>};

my $parser = XML::LibXML->new();
my $doc    = $parser->parse_string( $xmlstring );

my $foo = $doc->documentElement;

# TEST:$num_children=5;
my @children_1 = $foo->childNodes;
my @children_2 = $foo->childNodes;

ok($children_1[0]->can('unique_key'), 'unique_key method available')
    or exit -1;

# compare unique keys between all nodes in the above tiny document.
# Different nodes should have different keys; same nodes should have the same keys.
for my $c1(0..4){
    for my $c2(0..4){
        if($c1 == $c2){
            # TEST*$num_children
            ok($children_1[$c1]->unique_key eq $children_2[$c2]->unique_key,
                'Key for ' . $children_1[$c1]->nodeName .
                ' matches key from same node');
        }else{
            # TEST*($num_children)*($num_children-1)
            ok($children_1[$c1]->unique_key ne $children_2[$c2]->unique_key,
                'Key for ' . $children_1[$c1]->nodeName .
                ' does not match key for' . $children_2[$c2]->nodeName);
        }
    }
}