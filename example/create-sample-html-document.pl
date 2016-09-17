#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

{
    my $doc = XML::LibXML->createDocument;

    # A small Domain-Specific-Language for generating DOM:
    my $_text = sub {
        my ($content) = @_;

        return $doc->createTextNode($content);
    };

    # Short for element.
    my $_el = sub {
        my $name = shift;
        my $param = shift;
        my $attrs = {};
        if (ref($param) eq 'HASH')
        {
            $attrs = $param;
            $param = shift;
        }
        my $childs = $param;

        my $elem = $doc->createElementNS("", $name);

        while (my ($k, $v) = each %$attrs)
        {
            $elem->setAttribute($k, $v);
        }

        foreach my $child (@$childs)
        {
            $elem->appendChild($child);
        }

        return $elem;
    };

    my $html = $_el->(
        'html',
        [
            $_el->(
                'body',
                [
                    $_el->(
                        'p',
                        [
                            $_text->("Sample text inside the p element."),
                        ],
                    ),
                ],
            ),
        ],
    );
    $doc->setDocumentElement( $html );

    print $doc->toStringHTML();
    exit(0);

    # my $attr = $doc->createAttributeNS( "bar", "bar:foo", "test" );
    # $root->setAttributeNodeNS( $attr );
}

=head1 COPYRIGHT & LICENSE

Copyright 2016 by Shlomi Fish

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut