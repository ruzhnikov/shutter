###################################################
#
#  Copyright (C) 2021 Alexander Ruzhnikov <ruzhnikov85@gmail.com>
#
#  This file is part of Shutter.
#
#  Shutter is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#
#  Shutter is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with Shutter; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
###################################################

package Shutter::Draw::Utils;

use 5.010;
use utf8;
use strict;
use warnings;

use Gtk3;
use GooCanvas2;
use Glib qw/ TRUE FALSE /;
use Sort::Naturally;

sub points_to_canvas_points {
    my @points = @_;

    my $num_points = scalar(@points) / 2;
    my $result     = GooCanvas2::CanvasPoints::new( num_points => $num_points );

    for ( my $i = 0; $i < @points; $i += 2 ) {
        $result->set_point( $i / 2, $points[$i], $points[ $i + 1 ] );
    }

    return $result;
}

sub modify_text_in_properties {
    my $font_btn       = shift;
    my $textview       = shift;
    my $font_color     = shift;
    my $item           = shift;
    my $use_font       = shift;
    my $use_font_color = shift;

    my $font_descr = Pango::FontDescription->from_string( $font_btn->get_font_name );
    my $texttag    = Gtk3::TextTag->new;

    if ( $use_font->get_active && $use_font_color->get_active ) {
        $texttag->set( 'font-desc' => $font_descr, 'foreground-rgba' => $font_color->get_rgba );
    } elsif ( $use_font->get_active ) {
        $texttag->set( 'font-desc' => $font_descr );
    } elsif ( $use_font_color->get_active ) {
        $texttag->set( 'foreground-rgba' => $font_color->get_rgba );
    }

    my $texttagtable = Gtk3::TextTagTable->new;
    $texttagtable->add($texttag);

    my $text = Gtk3::TextBuffer->new($texttagtable);
    $text->signal_connect(
        'changed' => sub {
            $text->apply_tag( $texttag, $text->get_start_iter, $text->get_end_iter );
        } );

    $text->set_text(
        $textview->get_buffer->get_text(
            $textview->get_buffer->get_start_iter,
            $textview->get_buffer->get_end_iter, FALSE
        ) );
    $text->apply_tag( $texttag, $text->get_start_iter, $text->get_end_iter );
    $textview->set_buffer($text);

    return TRUE;
}

sub import_from_utheme_ctxt {
    my ( $icontheme, $context, $button ) = @_;

    my $menu_ctxt_items = Gtk3::Menu->new;
    my $size            = Gtk3::IconSize->lookup('dialog');

    for my $icon ( sort $icontheme->list_icons($context) ) {

        #objects from current theme (icons for specific contexts)
        my $utheme_ctxt_item = Gtk3::ImageMenuItem->new_with_label($icon);
        $utheme_ctxt_item->set( 'always_show_image' => TRUE );
        my $iconinfo = $icontheme->lookup_icon( $icon, $size, 'generic-fallback' );

        #save filename and generate thumbnail later
        #idle callback
        $utheme_ctxt_item->{'name'} = $iconinfo->get_filename;

        $menu_ctxt_items->append($utheme_ctxt_item);
    }

    $menu_ctxt_items->show_all;

    return $menu_ctxt_items;
}

sub import_from_session {
    my ( $button, $import_hash, $filename ) = @_;

    my $menu_session_objects = Gtk3::Menu->new;

    for my $key ( Sort::Naturally::nsort( keys %{$import_hash} ) ) {

        next unless exists $import_hash->{$key}->{'short'};
        next unless defined $import_hash->{$key}->{'short'};

        #init item with filename
        my $screen_menu_item = Gtk3::ImageMenuItem->new_with_label( $import_hash->{$key}->{'short'} );
        $screen_menu_item->set( 'always_show_image' => TRUE );

        #set sensitive == FALSE if image eq current file
        if ( $import_hash->{$key}->{'long'} eq $filename ) {
            $screen_menu_item->set_sensitive(FALSE);
        }

        #save filename and attributes
        $screen_menu_item->{'name'}         = $import_hash->{$key}->{'long'};
        $screen_menu_item->{'mime_type'}    = $import_hash->{$key}->{'mime_type'};
        $screen_menu_item->{'mtime'}        = $import_hash->{$key}->{'mtime'};
        $screen_menu_item->{'giofile'}      = $import_hash->{$key}->{'giofile'};
        $screen_menu_item->{'no_thumbnail'} = $import_hash->{$key}->{'no_thumbnail'};

        $menu_session_objects->append($screen_menu_item);
    }

    $menu_session_objects->show_all;

    return $menu_session_objects;
}

1;
