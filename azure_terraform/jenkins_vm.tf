############################################ terraform template
# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "jenkins" {
    name     = "jenkins"
    location = "westindia"

    tags {
        environment = "jenkins"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "jenkins_network" {
    name                = "jenkins_network"
    address_space       = ["10.0.0.0/16"]
    location            = "westindia"
    resource_group_name = "${azurerm_resource_group.jenkins.name}"

    tags {
        environment = "jenkins"
    }
}

# Create subnet
resource "azurerm_subnet" "jenkins_subnet" {
    name                 = "jenkins_subnet"
    resource_group_name  = "${azurerm_resource_group.jenkins.name}"
    virtual_network_name = "${azurerm_virtual_network.jenkins_network.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "jenkins_public_ip" {
    name                         = "jenkins_public_ip"
    location                     = "westindia"
    resource_group_name          = "${azurerm_resource_group.jenkins.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "jenkins"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "jenkns_security_group" {
    name                = "jenkins_network_security"
    location            = "westindia"
    resource_group_name = "${azurerm_resource_group.jenkins.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags {
        environment = "jenkins"
    }
}

# Create network interface
resource "azurerm_network_interface" "jenkins_network_interface" {
    name                      = "jenkins_nic"
    location                  = "westindia"
    resource_group_name       = "${azurerm_resource_group.jenkins.name}"
    network_security_group_id = "${azurerm_network_security_group.jenkns_security_group.id}"

    ip_configuration {
        name                          = "jenkins_ip_configuration"
        subnet_id                     = "${azurerm_subnet.jenkins_subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.jenkins_public_ip.id}"
    }

    tags {
        environment = "jenkins"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.jenkins.name}"
    }

    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "jenkins_storage" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.jenkins.name}"
    location                    = "westindia"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags {
        environment = "jenkins"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "jenkins_vm" {
    name                  = "jenkins_vm"
    location              = "westindia"
    resource_group_name   = "${azurerm_resource_group.jenkins.name}"
    network_interface_ids = ["${azurerm_network_interface.jenkins_network_interface.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "jenkins_disk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "jenkins"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC234pA9hD313o8mToSbQ28DNhYzs4/Nm2CQI7ypErhcgXxJ1H4R2lBGSOb2u4aAxEEh03SZlseRG2THEOfTmeBcOT+snTiCqyHM9FYLGBgWve/uyy0ssThuYSPySXBwXm/j6IVMBGIUEqjrZi+MJgj/iPce56CS1PRs/LnqFMk3BapT3J7DaMOTVEmIubOaXcOEbB8i1ITDATC+xLFVvIpc/dweoKVNGvoD8pmkMiog9YvHoKjNzHIAkDy1FDzw/yqr6wxNmIR/51ai49DyEPCSmZsWSC5nmgKEPutOF2AaEgqVDVClvTp9IEEJo4v+orpS+1pmi7v8w8bq948iF6H root@dt-ice-pulse"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.jenkins_storage.primary_blob_endpoint}"
    }

    tags {
        environment = "jenkins"
    }
}
