/*
 * COPYRIGHT (c) International Business Machines Corp. 2002-2017
 *
 * This program is provided under the terms of the Common Public License,
 * version 1.0 (CPL-1.0). Any use, reproduction or distribution for this
 * software constitutes recipient's acceptance of CPL-1.0 terms which can be
 * found in the file LICENSE file or at
 * https://opensource.org/licenses/cpl1.0.php
 */

%{
/* Parser for /etc/opencryptoki.conf */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "parser.h"

/* Ignore -Wsign-compare for autogenerated code. */
#pragma GCC diagnostic ignored "-Wsign-compare"

int line_num;

extern void yyerror(const char *s);
extern char *configparse_strdup(const char *s);
%}

%option noyywrap
%option nounput
%option noinput

%%

[\t ]+ 			/* ignore spaces */ ;

= 			return EQUAL;

\{			return BEGIN_DEF;

\}			return END_DEF;

\n			{
			  line_num++;
			  return EOL;
			}

#[^\n]*                 {
			  yylval.str = configparse_strdup(yytext + 1);
			  return COMMENT;
			}

[0-9]+"."[0-9]+		{ /* version */
			  unsigned long major, minor;
			  char *dot = strchr(yytext, '.');

			  *dot = '\0';
			  major = strtoul(yytext, NULL, 10);
			  minor = strtoul(dot + 1, NULL, 10);

			  yylval.num = (uint32_t)major << 16 | (uint32_t)minor;
			  return TOKVERSION;
			}

[0-9]+			{ /* number */
			  yylval.num = strtoul(yytext, NULL, 10);
			  return INTEGER;
			}

version                 return OCKVERSION;
slot                    return SLOT;
disable-event-support   return DISABLE_EVENT_SUPPORT;

[^\"= \t\n]+		{
			  yylval.str = configparse_strdup(yytext);
			  return STRING;
			}

\"[^\"\n]*\"		{
			  yylval.str = configparse_strdup(yytext+1);
			  if (yylval.str) yylval.str[strlen(yylval.str)-1]='\0';
			  return STRING;
			}

.			yyerror(yytext);

%%
