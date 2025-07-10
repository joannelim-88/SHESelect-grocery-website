
package model;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;


@Entity
public class Store implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    private String storeid;
    private String storename;
    private String description;
    private String address;
    private String status;
    
    @ManyToOne
    @JoinColumn(name = "grocerrid", nullable = false)
    private Grocer grocer;

    public Store() {
    }

    public Store(String storeid, String storename, String description, String address, String status, Grocer grocer) {
        this.storeid = storeid;
        this.storename = storename;
        this.description = description;
        this.address = address;
        this.status = status;
        this.grocer = grocer;
    }

    
    public String getStoreid() {
        return storeid;
    }

    public void setStoreid(String storeid) {
        this.storeid = storeid;
    }

    public String getStorename() {
        return storename;
    }

    public void setStorename(String storename) {
        this.storename = storename;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Grocer getGrocer() {
        return grocer;
    }

    public void setGrocer(Grocer grocer) {
        this.grocer = grocer;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (storeid != null ? storeid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Store)) {
            return false;
        }
        Store other = (Store) object;
        if ((this.storeid == null && other.storeid != null) || (this.storeid != null && !this.storeid.equals(other.storeid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Store[ id=" + storeid+ " ]";
    }
    
}
