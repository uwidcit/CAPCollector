"""CAP Collector models."""

__author__ = "arcadiy@google.com (Arkadii Yakovets)"


from django.db import models
from django.utils.translation import ugettext as _


class Alert(models.Model):
  """Alert entity definition."""
  uuid = models.CharField(_("Alert UUID"), max_length=36, db_index=True)
  created_at = models.DateTimeField(_("Alert creation time"), db_index=True)
  expires_at = models.DateTimeField(_("Alert expiration time"), db_index=True)
  content = models.TextField(_("Alert content"))
  updated = models.BooleanField(_("Alert replaced by an update or cancel"),
                                default=False, db_index=True)

  def __unicode__(self):
    return self.uuid


class AreaTemplate(models.Model):
  """Area template entity definition."""
  title = models.CharField(_("Template Title"), max_length=50)
  created_at = models.DateTimeField(_("Template creation time"),
                                    auto_now_add=True)
  last_modified_at = models.DateTimeField(_("Template last modification time"),
                                          auto_now=True)
  content = models.TextField(_("Template Content"))

  def __unicode__(self):
    return self.title

  class Meta:
    verbose_name = _("Area Template")
    verbose_name_plural = _("Area Templates")


class GeocodePreviewPolygon(models.Model):
  """Geocode preview polygon entity definition."""
  id = models.CharField("ID", max_length=255, primary_key=True)
  created_at = models.DateTimeField(_("Creation time"), auto_now_add=True)
  last_modified_at = models.DateTimeField(_("Last modification time"),
                                          auto_now=True)
  content = models.TextField(_("Polygons"))

  def __unicode__(self):
    return self.id

  @classmethod
  def make_key(cls, value_name, value):
    return '%s|%s' % (value_name, value)

  class Meta:
    verbose_name = _("Geocode Preview Polygon")
    verbose_name_plural = _("Geocode Preview Polygon")


class MessageTemplate(models.Model):
  """Message template entity definition."""
  title = models.CharField(_("Template Title"), max_length=50)
  created_at = models.DateTimeField(_("Template creation time"),
                                    auto_now_add=True)
  last_modified_at = models.DateTimeField(_("Template last modification time"),
                                          auto_now=True)
  content = models.TextField(_("Template Content"))

  def __unicode__(self):
    return self.title

  class Meta:
    verbose_name = _("Message Template")
    verbose_name_plural = _("Message Templates")
