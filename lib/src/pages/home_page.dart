import 'package:flutter/material.dart';
import 'package:MercaTEC/src/bloc/provider.dart';
import 'package:MercaTEC/src/models/producto_model.dart';

class HomePage extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos')
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton( context ),

      drawer: Drawer(
        child: Image(
          image:NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQroUj5xjuVM_vhu7fls1kakKCs51yHjAfMiFvAYyoosqlm3xfb&usqp=CAU')
  ) ,
      )
    );
  }


  Widget _crearListado(ProductosBloc productosBloc ) {

    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        
        if ( snapshot.hasData ) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productosBloc, productos[i] ),
          );

        } else {
          return Center( child: CircularProgressIndicator());
        }
      },
    );

  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductoModel producto ) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( direccion )=> productosBloc.borrarProducto(producto.id),
      child: Card(
        child: Column(
          children: <Widget>[

            ( producto.fotoUrl == null ) 
              ? Image(image: AssetImage('assets/no-image.png'))
              : FadeInImage(
                image: NetworkImage( producto.fotoUrl ),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            
            ListTile(
              title: Text('${ producto.titulo } - ${ producto.valor }'),
              subtitle: Text( producto.id ),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto ),
            ),

          ],
        ),
      )
    );


    

  }


  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.yellow,
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
    );
  }

}