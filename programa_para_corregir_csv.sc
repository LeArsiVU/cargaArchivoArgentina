using System;
using System.IO;
using System.Collections.Generic;

/*******Con este programa se corrige el problema que tuve con el csv que se 
bajó de  la página de coppel argentina (La que les dijo Jaime), el problema era
que en las filas que tenían los campos  vacíos le  faltaban se paradores 
al final y por esa razón no podía se cargado a la base de mysql.

se ejecutaría en la consola, al compilarlo, como 

ejecutable.exe "ruta/archivo.csv"

********/

namespace ProgramaCorrigeCSV{
    class Program{
        static int Main(string[] args){
             string path_entrada=" ";
          if(args.Length==0){
            Console.WriteLine("Ingrese la ruta del archivo CSV.");
            return 0;
          }else{
            path_entrada=args[0];
            Console.WriteLine("Ruta del archivo CSV: "+path_entrada);
          }

          if(File.Exists(path_entrada)){
          List<string> listA = new List<string>();

          int ncol=0,nrow=0,celdas=0;
          
          
          /**Lee el CSV**/
            using(var reader = new StreamReader(@path_entrada)){        
                   while (!reader.EndOfStream){
                          var line = reader.ReadLine();
                          if(!line.Equals("")){
                          var values = line.Split('\n');
                          listA.Add(values[0]);}
                    }          
            }

                 /*****Obtiene el nombre de las columnas*****/
                int k=0,j;

                for (j = 0; j< listA[0].Length; j++){
                    
                     if(listA[0][j]==';'){
                          ncol++;
                          k++;
                     }
                }

                string[] lineas= new string[listA.Count];
                int numSep=0,i;

                for (i=0;i<listA.Count;i++){                    
                 numSep=0;  
                 for (j = 0; j< listA[i].Length; j++){                    
                     if(listA[i][j]==';') numSep++;                     
                 }

                 if(numSep<ncol){                
                    for (j = 0; j< (ncol-numSep); j++)  listA[i]+=";";
                 }
                 lineas[i]= listA[i];
                 lineas[i].Replace("\n","");
                }

               /*******Guardar un archivo a CSV********/
           string path_salida=path_entrada.Substring(0,path_entrada.Length-4)+"_2.csv";
          Console.WriteLine("CSV de salida: "+path_salida);
           using (StreamWriter outfile = new StreamWriter(@path_salida)){

                for (int x = 0; x <listA.Count; x++){
                outfile.WriteLine(lineas[x]);
                }
           }

            Console.WriteLine("separadores "+ncol);
        }else{
              Console.WriteLine("El Archivo no existe");
        }
           /**************/
    return 0;
    }
}
}
