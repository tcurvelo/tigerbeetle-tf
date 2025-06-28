locals {
  cloud_init = templatefile(
    "${path.module}/../../templates/cloud-init.tpl",
    {
      service   = indent(4, file("${path.module}/../../templates/tigerbeetle.service"))
      pre_start = indent(4, file("${path.module}/../../templates/tigerbeetle-pre-start.sh"))
      install   = indent(4, file("${path.module}/../../templates/install.sh"))
    }
  )
}
