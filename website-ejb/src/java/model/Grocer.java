
package model;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;


@Entity
public class Grocer implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    private String grocerid;
    private String password;
    private String name;
    private int age;
    private String email;
    private int phoneno;
    private String address;
    
    @OneToMany(mappedBy = "grocer")
    private List<Store> stores;

    public Grocer() {
    }

    public Grocer(String grocerid, String password, String name, int age, String email, int phoneno, String address, List<Store> stores) {
        this.grocerid = grocerid;
        this.password = password;
        this.name = name;
        this.age = age;
        this.email = email;
        this.phoneno = phoneno;
        this.address = address;
        this.stores = stores;
    }

    
    public String getGrocerid() {
        return grocerid;
    }

    public void setGrocerid(String grocerid) {
        this.grocerid = grocerid;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getPhoneno() {
        return phoneno;
    }

    public void setPhoneno(int phoneno) {
        this.phoneno = phoneno;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public List<Store> getStores() {
        return stores;
    }

    public void setStores(List<Store> stores) {
        this.stores = stores;
    }
    
    
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (grocerid != null ? grocerid.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Grocer)) {
            return false;
        }
        Grocer other = (Grocer) object;
        if ((this.grocerid == null && other.grocerid != null) || (this.grocerid != null && !this.grocerid.equals(other.grocerid))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Grocer[ id=" + grocerid + " ]";
    }
    
}
