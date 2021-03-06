<%@page import="java.sql.*"%>
<%@page import="pilar.cls.ClsKonf" %>
<%@page import="pilar.cls.ClsOlahKata"%>
<%@page import="pilar.cls.ClsBasisdata" %>
<%@page import="pilar.cls.ClsOperasiBasisdata"%>
<%@page import="pilar.cls.ClsAdmin" %>
<%@page import="pilar.cls.ClsHTML"%>
<%@page import="pilar.cls.ClsKode"%>
<%@page import="pilar.cls.ClsCatat"%>

<%@include file="konf.jsp" %>

<% 
    /* variabel untuk diselipkan pada HTML/Javascript 
     * nilainya diambil dari berkas jsp ini/lain
     * bentuk penyelipannya pada HTML: ${vModKonfNamaData}
     */
    request.setAttribute("vModKonfNamaData", vModKonfNamaData);
    
    /* @sesi halaman admin */
    ClsKonf oKonf = new ClsKonf();
    ClsAdmin oAdmin = new ClsAdmin();
    try{
        if(session.getAttribute("sesID") != "" && !session.getId().equals("")){
            boolean vStatusSesi = oAdmin.fHalamanAdmin(session);
            if(!vStatusSesi){
                response.sendRedirect(ClsKonf.vKonfURL);
            }
        }
    }catch(Exception e){
        /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaBerkas = "modal.jsp";
                String vNamaModul = vModKonfNamaData;
                String vCatatan = vNamaBerkas + "#" + vNamaModul + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
    }
%>

<%
    /* @formulir */
    
    /* {OBYEK} */
    ClsHTML oForm = new ClsHTML(); /* obyek form */
    ClsOlahKata oKata = new ClsOlahKata(); /* obyek olah kata */
    ClsOperasiBasisdata oOpsBasisdata = new ClsOperasiBasisdata();
    
    /* {VARIABEL} */
    String vGetOperasi = oKata.fHapusSpasi(request.getParameter("o")),
        vHTMLModKonfNamaData = vModKonfNamaData,
        vHTMLGambarIcon = "", 
        vHTMLDataOperasi = "", 
        vHTMLOperasi = "",
        vHTMLForm = "",
        vLintang = "",
        vBujur = "",
        vKodeNegara = "",
        vKodeProvinsi = "",
        vKodeKabupaten = "",
        vKodeKecamatan = "";
    
    /* {OPERASI DATA} */
    
    /* [OD1] operasi ubah (+/-) data */
    if(vGetOperasi.equals("u")){
        vHTMLOperasi = "Ubah";
        
        /* ambil data */
        ResultSet vArrHasil = oOpsBasisdata.fArrAmbilDataDbKondisi("", 
                "", 
                vModKonfNamaTabel, 
                new String[]{"lintang","bujur","kode_geo_negara","kode_geo_provinsi","kode_geo_kabupaten"}, 
                new String[]{"nomor","1"},
                "nomor", "DESC", new String[]{"0","1"},"=");
        
        /* data nantinya ditampilkan di-form */
        while(vArrHasil.next()){
            vLintang = vArrHasil.getString("lintang");
            vBujur = vArrHasil.getString("bujur");
            vKodeNegara = vArrHasil.getString("kode_geo_negara");
            vKodeProvinsi = vArrHasil.getString("kode_geo_provinsi");
            vKodeKabupaten = vArrHasil.getString("kode_geo_kabupaten");
        }
        
        vLintang = (!vLintang.trim().equals("")) ? vLintang : "-6.2575356438802";
        vBujur = (!vBujur.trim().equals("")) ? vBujur : "106.814551771917";
        
        /* gambar icon */
        vHTMLGambarIcon = "ubahData32.png";
        vHTMLDataOperasi = "u";
    }
    
    
    /* {FORM DATA} */
    /* [FD1] form pada operasi tambah dan ubah data */
    if(vGetOperasi.equals("u")){
        
        /* {DATA TAMBAHAN} */
        /* -------------------------------- */
        String vSelNegara = "";
        String vSelProvinsi = "";
        String vSelKabupaten = "";
        
        /* B) operasi ubah data */
        if(vGetOperasi.equals("u")){
            /* 1) negara */
            vSelNegara = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_negara", vKodeNegara);
            /* 2) provinsi */
            vSelProvinsi = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_provinsi", vKodeProvinsi);
            /* 3) kabupaten */
            vSelKabupaten = oOpsBasisdata.fAmbilDataSelectHTML("", "", "tb_geo_kabupaten", vKodeKabupaten);
        }
        /* -------------------------------- */
        
        /* {FORM} */
        vHTMLForm = oForm.fForm("POST", "#", 
            new String[]{"Lintang", "Bujur","Negara","Provinsi","Kabupaten"}, 
            new String[]{"Lintang", "Bujur","KodeNegara","KodeProvinsi","KodeKabupaten"}, 
            new String[]{"@t","@t","s","s","s"}, 
            new String[]{vLintang,vBujur,vSelNegara,vSelProvinsi,vSelKabupaten}, 
            oForm.fTombol("bt", "idTombolSimpan","Simpan","tombolAjaxSimpan.png"),
            "idFormPengaturanLokasi", 
            "clsForm");
     }
    
    /* variabel tag */
    request.setAttribute("vHTMLForm", vHTMLForm); 
    request.setAttribute("vHTMLOperasi", vHTMLOperasi); 
    request.setAttribute("vHTMLGambarIcon", vHTMLGambarIcon);
    request.setAttribute("vHTMLDataOperasi", vHTMLDataOperasi);
    request.setAttribute("vLintang", vLintang);
    request.setAttribute("vBujur", vBujur);
%>

<%@ taglib tagdir="/WEB-INF/tags/desain/standar/halaman/admin/modul/modPengaturanLokasi" prefix="admin" %>
<admin:modal>
    <jsp:attribute name="atas">
        <!-- JS/CSS khusus di sini -->
        
	<script type="text/javascript">
            /* pemrogram: I Made Ariana (ariana@atlascitra.com)
             * waktu update: 2015.03.15/19:45 WIB
             */
            
            //<![CDATA[
                $(document).ready(function() {
                    /* {VARIABEL GLOBAL} */
                    var vTgl = new Date();
                    var vWaktu, vOperasi, vKode; /* data yang dikirim */
                    var vArrDataSvr = []; /* nilai data dari server */
                    var vKolomCari, vTeksCari;
                    
                    /* {BAGIAN TOMBOL[T]} */
                    
                    /* [T1] tombol simpan */
                    $('#idTombolSimpan').click(function(e){
                        /* cegah aksi bawaan */
                        e.preventDefault();

                        /* waktu */
                        vWaktu = vTgl.getTime();
                        
                        /* {DATA} */
                        /* data yg dikirim */
                        var vOperasi = '${vHTMLDataOperasi}';
                        var vLintang = $('#idLintang').val();
                        var vBujur = $('#idBujur').val();
                        var vKodeNegara = $('#idKodeNegara').val();
                        var vKodeProvinsi = $('#idKodeProvinsi').val();
                        var vKodeKabupaten = $('#idKodeKabupaten').val();
                        
                        /* bila kode dan nama diisi */
                        if(vLintang != "" && vBujur != ""){
                            /* tampilkan animasi gif */
                            $("#idGbrTombol").attr('src','${URLModAdpubGambarAnimasi}/putaranSebar.gif');

                            /* [1] req. dilakukan */
                            var vReqSimpanData = $.ajax({
                                url: "${URLMod}/proses.jsp?w=" + vWaktu,
                                type: "POST",
                                data: { dtOperasi: vOperasi, 
                                    dtLintang : vLintang, 
                                    dtBujur : vBujur,
                                    dtKodeNegara: vKodeNegara,
                                    dtKodeProvinsi: vKodeProvinsi,
                                    dtKodeKabupaten: vKodeKabupaten
                                },
                                dataType: "html"
                            });


                            /* [2] req. selesai */
                            vReqSimpanData.done(function(vFDataSvr) {
                                /* [#] notifikasi */
                                
                                /* mengubah gambar tombol */
                                $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSukses.png');
                                
                                /* operasi tambahan aka post operation setelah 3000 ms */
                                setTimeout(function(e){
                                    /* menampilkan bagian pencarian dan tabel */
                                    $(window.parent.document).find("#idDivCari").removeAttr('style','display:none');
                                    $(window.parent.document).find("#idDivTabelData").removeAttr('style','display:none');
                                    $(window.parent.document).find("#idDivTambah48").attr('style','display:none');

                                    /* mengubah gambar tombol */
                                    $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxSimpan.png');
                                    
                                },1000);
                            });

                            /* [3] req. gagal */
                            vReqSimpanData.fail(function(e, textStatus ) {
                                alert( "Permintaan ke server tidak berhasil: " + textStatus );
                                $("#idGbrTombol").attr('src','${URLModAdpubGambarTombol}/tombolAjaxGagal.png');
                            });
                            
                            /* menyembunyikan pesan modal */
                            $("#idPesanModal").fadeOut().css('border','0px solid red');
                            $("#idPesanModal").removeClass('clsTampilkanPesan');
                            $("#idPesanModal").hide().addClass('clsSembunyikanPesan');
                            
                            $("#idPesanModal").html("");
                        }else{
                            /* menampilkan pesan modal */
                            $("#idPesanModal").removeClass('clsSembunyikanPesan');
                            $("#idPesanModal").hide().addClass('clsTampilkanPesan');
                            $("#idPesanModal").fadeIn().css('border','1px solid red');
                        }
                        
                    });                    

                    
                    /* {SELECT CHANGE} */
                    /* 1) Negara */
                    $('#idKodeNegara').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeNegara = this.value;
                        /* req ajax mengambil data provinsi */
                        /* [1] req. dilakukan */
                        var vReqSimpanData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { dtOperasi: "s", 
                                dtKodeData: "provinsi",
                                dtKodeRef: vKodeNegara
                            },
                            dataType: "html"
                        });


                        /* [2] req. selesai */
                        vReqSimpanData.done(function(vFDataSvr){
                            /* [#] notifikasi */
                            /* masukkan data provinsi keluaran proses.jsp ke select */
                            var vArrDataSvr = [];

                            if(vFDataSvr.trim() != ""){
                                vArrDataSvr = vFDataSvr.split('@');
                            }

                            //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                            if(vFDataSvr.trim() != "" && parseInt(vArrDataSvr[0]) > parseInt(0)){
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());

                                /* hapus option dalam select */
                                $('#idKodeProvinsi option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeProvinsi').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Provinsi' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeProvinsi').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                        )
                                    );
                                });
                            }else{
                                /* hapus option dalam select: provinsi */
                                $('#idKodeProvinsi option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kabupaten */
                                $('#idKodeKabupaten option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kecamatan */
                                $('#idKodeKecamatan option').each(function() {
                                    $(this).remove();
                                });
                            }
                        });

                        /* [3] req. gagal */
                        vReqSimpanData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    });
                    
                    /* 2) Provinsi */
                    $('#idKodeProvinsi').on('change', function() {
                        /* waktu */
                        vWaktu = vTgl.getTime();
                        var vKodeNegara =   $('#idKodeNegara :selected').val();
                        var vKodeProvinsi = this.value;
                        /* req ajax mengambil data provinsi */
                        /* [1] req. dilakukan */
                        var vReqSimpanData = $.ajax({
                            url: "${URLMod}/proses.jsp?w=" + vWaktu,
                            type: "POST",
                            data: { dtOperasi: "s", 
                                dtKodeData: "kabupaten",
                                dtKodeRef: vKodeNegara + "#" + vKodeProvinsi,
                            },
                            dataType: "html"
                        });


                        /* [2] req. selesai */
                        vReqSimpanData.done(function(vFDataSvr){
                            /* [#] notifikasi */
                            /* masukkan data provinsi keluaran proses.jsp ke select */
                            var vArrDataSvr = [];

                            if(vFDataSvr.trim() != ""){
                                vArrDataSvr = vFDataSvr.split('@');
                            }

                            //console.log("vArrDataSvr[0]: " + vArrDataSvr[0]);
                            if(vFDataSvr.trim() != "" && parseInt(vArrDataSvr[0]) > parseInt(0)){
                                /* parsing data JSON */
                                var oData = jQuery.parseJSON(vArrDataSvr[1].trim());

                                /* hapus option dalam select */
                                $('#idKodeKabupaten option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* option awal */
                                $('#idKodeKabupaten').append(
                                        $('<option>', { 
                                            value: '',
                                            text : 'Pilih Kabupaten' 
                                                      }
                                        )
                                );
                                /* untuk setiap data dalam oData */
                                $.each(oData,function(id,el){
                                    $('#idKodeKabupaten').append(
                                        $('<option>', { 
                                            value: el.kode,
                                            text : el.kode + " " + el.nama 
                                                      }
                                          )
                                    );
                                });
                            }else{
                                /* hapus option dalam select: kabupaten */
                                $('#idKodeKabupaten option').each(function() {
                                    $(this).remove();
                                });
                                
                                /* hapus option dalam select: kecamatan */
                                $('#idKodeKecamatan option').each(function() {
                                    $(this).remove();
                                });
                            }
                        });

                        /* [3] req. gagal */
                        vReqSimpanData.fail(function(e, textStatus ) {
                            alert( "Permintaan ke server tidak berhasil: " + textStatus );
                        });
                    });
                    
                    /* peta */
                    var vMap;
                    var iconBase;
                    var vPenandaTempat;
                    var vPenandaHasilCari;
                    /* koordinat awal: Indonesia */
                    var vLatitudeAwal = '${vLintang}';
                    var vLongitudeAwal = '${vBujur}';

                    /* muat google maps */
                    google.maps.event.addDomListener(window, 'load', fInisialisasiPeta(vLatitudeAwal,vLongitudeAwal,3)); 

                    /* ketika kolom lintang di-blur */
                    $('#idLintang').blur(function(e){
                        e.preventDefault();
                        /* muat google maps */
                        if($('#idBujur').val() != ""){
                            google.maps.event.addDomListener(window, 'load', fInisialisasiPeta($("#idLintang").val(),$("#idBujur").val(),18));
                        }
                    });

                    /* ketika kolom lintang di-blur */
                    $('#idBujur').blur(function(e){
                        e.preventDefault();
                        /* muat google maps */
                        if($('#idLintang').val() != ""){
                            google.maps.event.addDomListener(window, 'load', fInisialisasiPeta($("#idLintang").val(),$("#idBujur").val(),18));
                        }
                    });

                    if($('#idLintang').val() != '' && $('#idBujur').val() != ''){
                        google.maps.event.addDomListener(window, 'load', fInisialisasiPeta($("#idLintang").val(),$("#idBujur").val(),18));
                    }


                    /* fungsi inisialisasi peta */
                    function fInisialisasiPeta(vFLatitude,vFLongitude,vFZoom) {
                        var vPusatKoordinat = new google.maps.LatLng(vFLatitude, vFLongitude);
                        /* opsi peta */
                        var vOpsiPeta = {
                            zoom: vFZoom,
                            center: vPusatKoordinat,
                            scrollwheel: true,
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            mapTypeControl: true,
                            mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DEFAULT },
                            navigationControl: true,
                            navigationControlOptions: {style: google.maps.NavigationControlStyle.DEFAULT }
                        };

                        var vArrPenandaTempat = [];

                        /* objek peta */
                        vMap = new google.maps.Map(document.getElementById('idPetaKanvasModal'),vOpsiPeta);

                        // {AWAL}
                        /* penanda */
                        vPenandaTempat = new google.maps.Marker({
                                draggable: true,
                                map: vMap,
                                icon: '${URLModAdpubGambarPeta}/lokasiTanda.png',
                                animation: google.maps.Animation.DROP,
                                position: vPusatKoordinat
                            });

                        /* membuat kolom pencarian */
                        var vMasukanPencarian = /** @type {HTMLInputElement} */(document.getElementById('pac-input'));
                        vMap.controls[google.maps.ControlPosition.TOP_LEFT].push(vMasukanPencarian);

                        /* hasil pencarian */
                        var searchBox = new google.maps.places.SearchBox(
                            /** @type {HTMLInputElement} */(vMasukanPencarian));

                        // {MENCARI LOKASI}
                        // Listen for the event fired when the user selects an item from the
                        // pick list. Retrieve the matching places for that item.
                        google.maps.event.addListener(searchBox, 'places_changed', function() {
                            var vArrTempat = searchBox.getPlaces();

                            if (vArrTempat.length == 0) {
                                return;
                            }

                            for (var i = 0, vPenandaHasilCari; vPenandaHasilCari = vArrPenandaTempat[i]; i++) {
                                vPenandaHasilCari.setMap(null);
                            }

                            /* untuk setiap tempat, berikan icon, nama tempat, dan lokasi */
                            vArrPenandaTempat = [];
                            var vArrCakupanTempat = new google.maps.LatLngBounds();
                            for (var i = 0, vTempat; vTempat = vArrTempat[i]; i++) {

                                /* buat penanda untuk setiap tempat */
                                vPenandaTempat = new google.maps.Marker({
                                    map: vMap,
                                    icon: '${URLModAdpubGambarPeta}/lokasiTanda.png',
                                    title: vTempat.name,
                                    position: vTempat.geometry.location,
                                    draggable: true,
                                    animation: google.maps.Animation.DROP,
                                    idLokasi: 'idLokasi' + i
                                });

                                vArrPenandaTempat.push(vPenandaTempat);                    
                                vArrCakupanTempat.extend(vTempat.geometry.location);

                                google.maps.event.addListener(vPenandaTempat,'dragend',function() {
                                    var vIdLokasi = this.idLokasi;
                                    var lat = document.getElementById('lat_' + vIdLokasi);
                                    var lng = document.getElementById('lng_' + vIdLokasi);

                                    var vLintangBujur = this.getPosition();

                                    $("#idLintang").val(vLintangBujur.lat());
                                    $("#idBujur").val(vLintangBujur.lng());
                                    console.log('vArrPenandaTempat ID -> ' + vPenandaTempat.idLokasi);
                                });
                            }

                            vMap.fitBounds(vArrCakupanTempat);
                        });
                        /* {AKHIR MENCARI LOKASI} */

                        // Bias the SearchBox results towards places that are within the bounds of the
                        // current map's viewport.
                        google.maps.event.addListener(vMap, 'bounds_changed', function() {
                            var vArrCakupanTempat = vMap.getBounds();
                            searchBox.setBounds(vArrCakupanTempat);
                        });            


                        google.maps.event.addListener(vPenandaTempat,'dragend',function() {
                            var vLintangBujur = vPenandaTempat.getPosition();
                            $("#idLintang").val(vLintangBujur.lat());
                            $("#idBujur").val(vLintangBujur.lng());
                            console.log('vArrPenandaTempat ID -> ' + vPenandaTempat.idLokasi);
                        });

                        google.maps.event.trigger(vPenandaTempat,"click");
                    }

                    function fToggleBounce(vFMarker) {
                      if (vFMarker.getAnimation() != null) {
                        vFMarker.setAnimation(null);
                      } else {
                        vFMarker.setAnimation(google.maps.Animation.BOUNCE);
                      }
                    }

                    
                });
            //]]>     
	</script>
  </jsp:attribute>
  
  <jsp:attribute name="isi">
    <div class="clsModalIsi">
        <div class="clsModalJudul">
            <button type="button" class="close" onclick="Custombox.close();">&times;</button>
            <h4><img src="${URLModAdpubGambarData}/${vHTMLGambarIcon}"/> &nbsp; <strong>${vHTMLOperasi} Data ${vModKonfNamaData}</strong></h4>
        </div>
        <div class="clsModalBody">
            <center>
            <div id="idPesanModal" class="clsSembuyikanPesan"></div>
            
            <input id="pac-input" class="controls" type="text" placeholder="Search Box">
            <div id="idPetaKanvasModal"></div>
            ${vHTMLForm}
            </center>
        </div>
    </div>
  </jsp:attribute>
</admin:modal>