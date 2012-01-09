/* -*- c-file-style: "ruby"; indent-tabs-mode: nil -*- */
/*
 *  ocidatetime.c
 *
 * $Author: kubo $
 * $Date: 2011-06-14 20:45:16 +0900 (Tue, 14 Jun 2011) $
 *
 * Copyright (C) 2005-2008 KUBO Takehiro <kubo@jiubao.org>
 *
 */
#include "oci8.h"

VALUE oci8_make_ocidate(OCIDate *od)
{
    return rb_ary_new3(6,
                       INT2FIX(od->OCIDateYYYY),
                       INT2FIX(od->OCIDateMM),
                       INT2FIX(od->OCIDateDD),
                       INT2FIX(od->OCIDateTime.OCITimeHH),
                       INT2FIX(od->OCIDateTime.OCITimeMI),
                       INT2FIX(od->OCIDateTime.OCITimeSS));
}

OCIDate *oci8_set_ocidate(OCIDate *od, VALUE val)
{
    long year, month, day, hour, minute, second;

    Check_Type(val, T_ARRAY);
    if (RARRAY_LEN(val) != 6) {
        rb_raise(rb_eRuntimeError, "invalid array size %ld", RARRAY_LEN(val));
    }
    /* year */
    year = NUM2LONG(RARRAY_PTR(val)[0]);
    if (year < -4712 || 9999 < year) {
        rb_raise(rb_eRuntimeError, "out of year range: %ld", year);
    }
    od->OCIDateYYYY = (sb2)year;
    /* month */
    month = NUM2LONG(RARRAY_PTR(val)[1]);
    if (month < 0 || 12 < month) {
        rb_raise(rb_eRuntimeError, "out of month range: %ld", month);
    }
    od->OCIDateMM = (ub1)month;
    /* day */
    day = NUM2LONG(RARRAY_PTR(val)[2]);
    if (day < 0 || 31 < day) {
        rb_raise(rb_eRuntimeError, "out of day range: %ld", day);
    }
    od->OCIDateDD = (ub1)day;
    /* hour */
    hour = NUM2LONG(RARRAY_PTR(val)[3]);
    if (hour < 0 || 23 < hour) {
        rb_raise(rb_eRuntimeError, "out of hour range: %ld", hour);
    }
    od->OCIDateTime.OCITimeHH = (ub1)hour;
    /* minute */
    minute = NUM2LONG(RARRAY_PTR(val)[4]);
    if (minute < 0 || 59 < minute) {
        rb_raise(rb_eRuntimeError, "out of minute range: %ld", minute);
    }
    od->OCIDateTime.OCITimeMI = (ub1)minute;
    /* second */
    second = NUM2LONG(RARRAY_PTR(val)[5]);
    if (second < 0 || 59 < second) {
        rb_raise(rb_eRuntimeError, "out of second range: %ld", second);
    }
    od->OCIDateTime.OCITimeSS = (ub1)second;
    return od;
}

static VALUE bind_ocidate_get(oci8_bind_t *obind, void *data, void *null_struct)
{
    return oci8_make_ocidate((OCIDate *)data);
}

static void bind_ocidate_set(oci8_bind_t *obind, void *data, void **null_structp, VALUE val)
{
    oci8_set_ocidate((OCIDate *)data, val);
}

static void bind_ocidate_init(oci8_bind_t *obind, VALUE svc, VALUE val, VALUE length)
{
    obind->value_sz = sizeof(OCIDate);
    obind->alloc_sz = sizeof(OCIDate);
}

static const oci8_bind_class_t bind_ocidate_class = {
    {
        NULL,
        oci8_bind_free,
        sizeof(oci8_bind_t)
    },
    bind_ocidate_get,
    bind_ocidate_set,
    bind_ocidate_init,
    NULL,
    NULL,
    NULL,
    NULL,
    SQLT_ODT,
};

#if defined RUNTIME_API_CHECK || ORACLE_CLIENT_VERSION >= ORAVER_9_0

static void bind_init_elem_common(oci8_bind_t *obind, VALUE svc, ub4 type)
{
    ub4 idx = 0;
    sword rv;

    do {
        rv = OCIDescriptorAlloc(oci8_envhp, (dvoid*)((dvoid**)obind->valuep + idx), type, 0, 0);
        if (rv != OCI_SUCCESS)
            oci8_env_raise(oci8_envhp, rv);
    } while (++idx < obind->maxar_sz);
}

static void bind_free_common(oci8_base_t *base, ub4 type)
{
    oci8_bind_t *obind = (oci8_bind_t *)base;

    if (obind->valuep != NULL) {
        ub4 idx = 0;
        void **pp = (void**)obind->valuep;

        do {
            if (pp[idx] != NULL) {
                OCIDescriptorFree(pp[idx], type);
                pp[idx] = NULL;
            }
        } while (++idx < obind->maxar_sz);
    }
    oci8_bind_free(base);
}

VALUE oci8_make_ocitimestamp_tz(OCIDateTime *dttm)
{
    sb2 year;
    ub1 month;
    ub1 day;
    ub1 hour;
    ub1 minute;
    ub1 sec;
    ub4 fsec;
    sb1 tz_hour;
    sb1 tz_minute;

    oci_lc(OCIDateTimeGetDate(oci8_envhp, oci8_errhp, dttm, &year, &month, &day));
    oci_lc(OCIDateTimeGetTime(oci8_envhp, oci8_errhp, dttm, &hour, &minute, &sec, &fsec));
    oci_lc(OCIDateTimeGetTimeZoneOffset(oci8_envhp, oci8_errhp, dttm, &tz_hour, &tz_minute));
    return rb_ary_new3(9,
                       INT2FIX(year),
                       INT2FIX(month),
                       INT2FIX(day),
                       INT2FIX(hour),
                       INT2FIX(minute),
                       INT2FIX(sec),
                       INT2FIX(fsec),
                       INT2FIX(tz_hour),
                       INT2FIX(tz_minute));
}

OCIDateTime *oci8_set_ocitimestamp_tz(OCIDateTime *dttm, VALUE val, VALUE svc)
{
    long year;
    long month;
    long day;
    long hour;
    long minute;
    long sec;
    long fsec;
    OraText *tz;
    size_t tzlen;
    char tz_str[32];
    OCISession *seshp = NULL;

    Check_Type(val, T_ARRAY);
    if (RARRAY_LEN(val) != 9) {
        rb_raise(rb_eRuntimeError, "invalid array size %ld", RARRAY_LEN(val));
    }
    /* year */
    year = NUM2LONG(RARRAY_PTR(val)[0]);
    if (year < -4712 || 9999 < year) {
        rb_raise(rb_eRuntimeError, "out of year range: %ld", year);
    }
    /* month */
    month = NUM2LONG(RARRAY_PTR(val)[1]);
    if (month < 0 || 12 < month) {
        rb_raise(rb_eRuntimeError, "out of month range: %ld", month);
    }
    /* day */
    day = NUM2LONG(RARRAY_PTR(val)[2]);
    if (day < 0 || 31 < day) {
        rb_raise(rb_eRuntimeError, "out of day range: %ld", day);
    }
    /* hour */
    hour = NUM2LONG(RARRAY_PTR(val)[3]);
    if (hour < 0 || 23 < hour) {
        rb_raise(rb_eRuntimeError, "out of hour range: %ld", hour);
    }
    /* minute */
    minute = NUM2LONG(RARRAY_PTR(val)[4]);
    if (minute < 0 || 60 < minute) {
        rb_raise(rb_eRuntimeError, "out of minute range: %ld", minute);
    }
    /* second */
    sec = NUM2LONG(RARRAY_PTR(val)[5]);
    if (sec < 0 || 60 < sec) {
        rb_raise(rb_eRuntimeError, "out of second range: %ld", sec);
    }
    /* sec_fraction */
    fsec = NUM2LONG(RARRAY_PTR(val)[6]);
    if (fsec < 0 || 1000000000 < fsec) {
        rb_raise(rb_eRuntimeError, "out of sec_fraction range: %ld", fsec);
    }
    /* time zone */
    if (NIL_P(RARRAY_PTR(val)[7]) && NIL_P(RARRAY_PTR(val)[8])) {
        if (!NIL_P(svc)) {
            /* use session timezone. */
            seshp = oci8_get_oci_session(svc);
        }
        tz = NULL;
        tzlen = 0;
    } else {
        snprintf(tz_str, sizeof(tz_str), "%+02ld:%02ld",
                 NUM2LONG(RARRAY_PTR(val)[7]),
                 NUM2LONG(RARRAY_PTR(val)[8]));
        tz_str[sizeof(tz_str) - 1] = '\0';
        tz = (OraText*)tz_str;
        tzlen = strlen(tz_str);
    }
    /* construct */
    oci_lc(OCIDateTimeConstruct(seshp ? (void*)seshp : (void*)oci8_envhp, oci8_errhp, dttm,
                                (sb2)year,
                                (ub1)month,
                                (ub1)day,
                                (ub1)hour,
                                (ub1)minute,
                                (ub1)sec,
                                (ub4)fsec,
                                tz, tzlen));
    return dttm;
}

static VALUE bind_ocitimestamp_tz_get(oci8_bind_t *obind, void *data, void *null_struct)
{
    return oci8_make_ocitimestamp_tz(*(OCIDateTime **)data);
}

static void bind_ocitimestamp_tz_set(oci8_bind_t *obind, void *data, void **null_structp, VALUE val)
{
    oci8_base_t *parent;
    oci8_base_t *svcctx;

    parent = obind->base.parent;
    if (parent != NULL && parent->type == OCI_HTYPE_STMT) {
        svcctx = parent->parent;
    } else {
        svcctx = parent;
    }
    if (svcctx == NULL || svcctx->type != OCI_HTYPE_SVCCTX) {
        rb_raise(rb_eRuntimeError, "oci8lib.so internal error [%s:%d, %p, %d, %p, %d]",
                 __FILE__, __LINE__,
                 parent, parent ? parent->type : -1,
                 svcctx, svcctx ? svcctx->type : -1);
    }
    oci8_set_ocitimestamp_tz(*(OCIDateTime **)data, val, svcctx->self);
}

static void bind_ocitimestamp_tz_init(oci8_bind_t *obind, VALUE svc, VALUE val, VALUE length)
{
    oci8_link_to_parent((oci8_base_t*)obind, (oci8_base_t*)oci8_get_svcctx(svc));
    obind->value_sz = sizeof(OCIDateTime *);
    obind->alloc_sz = sizeof(OCIDateTime *);
}

static void bind_ocitimestamp_tz_init_elem(oci8_bind_t *obind, VALUE svc)
{
    bind_init_elem_common(obind, svc, OCI_DTYPE_TIMESTAMP_TZ);
}

static void bind_ocitimestamp_tz_free(oci8_base_t *base)
{
    bind_free_common(base, OCI_DTYPE_TIMESTAMP_TZ);
}

static const oci8_bind_class_t bind_ocitimestamp_tz_class = {
    {
        NULL,
        bind_ocitimestamp_tz_free,
        sizeof(oci8_bind_t)
    },
    bind_ocitimestamp_tz_get,
    bind_ocitimestamp_tz_set,
    bind_ocitimestamp_tz_init,
    bind_ocitimestamp_tz_init_elem,
    NULL,
    NULL,
    NULL,
    SQLT_TIMESTAMP_TZ
};

VALUE oci8_make_ociinterval_ym(OCIInterval *s)
{
    sb4 year;
    sb4 month;

    oci_lc(OCIIntervalGetYearMonth(oci8_envhp, oci8_errhp, &year, &month, s));
    return rb_ary_new3(2, INT2FIX(year), INT2FIX(month));
}

OCIInterval *oci8_set_ociinterval_ym(OCIInterval *intvl, VALUE val)
{
    sb4 year;
    sb4 month;

    Check_Type(val, T_ARRAY);
    if (RARRAY_LEN(val) != 2) {
        rb_raise(rb_eRuntimeError, "invalid array size %ld", RARRAY_LEN(val));
    }
    year = NUM2INT(RARRAY_PTR(val)[0]);
    month = NUM2INT(RARRAY_PTR(val)[1]);
    if (oracle_client_version >= ORAVERNUM(9, 2, 0, 3, 0)) {
        oci_lc(OCIIntervalSetYearMonth(oci8_envhp, oci8_errhp,
                                       year, month, intvl));
    } else {
        /* Workaround for Bug 2227982 */
        char buf[64];
        char *sign = "";

        if (year < 0 && month != 0) {
            year += 1;
            month -= 12;
        }
        if (year < 0 || month < 0) {
            sign = "-";
            year = -year;
            month = -month;
        }
        sprintf(buf, "%s%d-%d", sign, year, month);
        oci_lc(OCIIntervalFromText(oci8_envhp, oci8_errhp, (text*)buf, strlen(buf), intvl));
    }
    return intvl;
}

VALUE oci8_make_ociinterval_ds(OCIInterval *s)
{
    sb4 day;
    sb4 hour;
    sb4 minute;
    sb4 sec;
    sb4 fsec;

    oci_lc(OCIIntervalGetDaySecond(oci8_envhp, oci8_errhp, &day, &hour, &minute, &sec, &fsec, s));
    return rb_ary_new3(5,
                       INT2FIX(day), INT2FIX(hour),
                       INT2FIX(minute), INT2FIX(sec),
                       INT2FIX(fsec));
}

OCIInterval *oci8_set_ociinterval_ds(OCIInterval *intvl, VALUE val)
{
    sb4 day;
    sb4 hour;
    sb4 minute;
    sb4 sec;
    sb4 fsec;

    Check_Type(val, T_ARRAY);
    if (RARRAY_LEN(val) != 5) {
        rb_raise(rb_eRuntimeError, "invalid array size %ld", RARRAY_LEN(val));
    }
    day = NUM2INT(RARRAY_PTR(val)[0]);
    hour = NUM2INT(RARRAY_PTR(val)[1]);
    minute = NUM2INT(RARRAY_PTR(val)[2]);
    sec = NUM2INT(RARRAY_PTR(val)[3]);
    fsec = NUM2INT(RARRAY_PTR(val)[4]);
    if (oracle_client_version >= ORAVERNUM(9, 2, 0, 3, 0)) {
        oci_lc(OCIIntervalSetDaySecond(oci8_envhp, oci8_errhp,
                                       day, hour, minute, sec, fsec, intvl));
    } else {
        /* Workaround for Bug 2227982 */
        char buf[64];
        char *sign = "";

        if (day == 0) {
            if (hour < 0) {
                sign = "-";
                hour = -hour;
            } else if (minute < 0) {
                sign = "-";
                minute = -minute;
            } else if (sec < 0) {
                sign = "-";
                sec = -sec;
            } else if (fsec < 0) {
                sign = "-";
                fsec = -fsec;
            }
        }
        sprintf(buf, "%s%d %02d:%02d:%02d.%09d", sign, day, hour, minute, sec, fsec);
        oci_lc(OCIIntervalFromText(oci8_envhp, oci8_errhp, (text*)buf, strlen(buf), intvl));
    }
    return intvl;
}


static VALUE bind_ociinterval_ym_get(oci8_bind_t *obind, void *data, void *null_struct)
{
    return oci8_make_ociinterval_ym(*(OCIInterval **)data);
}

static void bind_ociinterval_ym_set(oci8_bind_t *obind, void *data, void **null_structp, VALUE val)
{
    oci8_set_ociinterval_ym(*(OCIInterval **)data, val);
}

static void bind_ociinterval_ym_init(oci8_bind_t *obind, VALUE svc, VALUE val, VALUE length)
{
    obind->value_sz = sizeof(OCIInterval*);
    obind->alloc_sz = sizeof(OCIInterval*);
}

static void bind_ociinterval_ym_init_elem(oci8_bind_t *obind, VALUE svc)
{
    bind_init_elem_common(obind, svc, OCI_DTYPE_INTERVAL_YM);
}

static void bind_ociinterval_ym_free(oci8_base_t *base)
{
    bind_free_common(base, OCI_DTYPE_INTERVAL_YM);
}

static VALUE bind_ociinterval_ds_get(oci8_bind_t *obind, void *data, void *null_struct)
{
    return oci8_make_ociinterval_ds(*(OCIInterval **)data);
}

static void bind_ociinterval_ds_set(oci8_bind_t *obind, void *data, void **null_structp, VALUE val)
{
    oci8_set_ociinterval_ds(*(OCIInterval **)data, val);
}

static void bind_ociinterval_ds_init(oci8_bind_t *obind, VALUE svc, VALUE val, VALUE length)
{
    obind->value_sz = sizeof(OCIInterval *);
    obind->alloc_sz = sizeof(OCIInterval *);
}

static void bind_ociinterval_ds_init_elem(oci8_bind_t *obind, VALUE svc)
{
    bind_init_elem_common(obind, svc, OCI_DTYPE_INTERVAL_DS);
}

static void bind_ociinterval_ds_free(oci8_base_t *base)
{
    bind_free_common(base, OCI_DTYPE_INTERVAL_DS);
}

static const oci8_bind_class_t bind_ociinterval_ym_class = {
    {
        NULL,
        bind_ociinterval_ym_free,
        sizeof(oci8_bind_t)
    },
    bind_ociinterval_ym_get,
    bind_ociinterval_ym_set,
    bind_ociinterval_ym_init,
    bind_ociinterval_ym_init_elem,
    NULL,
    NULL,
    NULL,
    SQLT_INTERVAL_YM
};

static const oci8_bind_class_t bind_ociinterval_ds_class = {
    {
        NULL,
        bind_ociinterval_ds_free,
        sizeof(oci8_bind_t)
    },
    bind_ociinterval_ds_get,
    bind_ociinterval_ds_set,
    bind_ociinterval_ds_init,
    bind_ociinterval_ds_init_elem,
    NULL,
    NULL,
    NULL,
    SQLT_INTERVAL_DS
};

#endif /* defined RUNTIME_API_CHECK || ORACLE_CLIENT_VERSION >= ORAVER_9_0 */

void Init_oci_datetime(void)
{
    oci8_define_bind_class("OCIDate", &bind_ocidate_class);

#if defined RUNTIME_API_CHECK || ORACLE_CLIENT_VERSION >= ORAVER_9_0
    if (oracle_client_version >= ORAVER_9_0) {
        oci8_define_bind_class("OCITimestampTZ", &bind_ocitimestamp_tz_class);
        oci8_define_bind_class("OCIIntervalYM", &bind_ociinterval_ym_class);
        oci8_define_bind_class("OCIIntervalDS", &bind_ociinterval_ds_class);
    }
#endif

}
